//
//  TheMetStore.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import Combine
import Foundation
import WidgetKit

extension FileManager {
    static func getSharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier:
                "group.org.example.TheMet.objects"
        )!
    }
}

class TheMetStore: ObservableObject {
    @Published var objects: [Object] = []
    let service = TheMetService()
    let maxIndex: Int

    init(maxIndex: Int = 30) {
        self.maxIndex = maxIndex
    }

    func fetchObjects(query: String) async throws {
        if let objectIds = try await service.getObjectIds(query: query) {
            for (index, objectId) in objectIds.objectIDs.enumerated()
            where index < maxIndex {
                if let object = try await service.getObject(
                    objectId: objectId
                ) {
                    await MainActor.run {
                        objects.append(object)
                    }
                }
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "TheMetWidget")
        }
    }

    func writeObjects() {
        let archiveURL = FileManager.getSharedContainerURL()
            .appendingPathComponent("objects.json")

        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(objects) {
            do {
                try dataToSave.write(to: archiveURL)
            } catch {
                print("Store error: Can't write objects!")
            }
        }
    }
}
