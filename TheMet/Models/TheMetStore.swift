//
//  TheMetStore.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import Combine
import Foundation

class TheMetStore: ObservableObject {
    @Published var objects: [Object] = []
    let service = TheMetService()
    let maxIndex: Int

    init(maxIndex: Int = 30) {
        self.maxIndex = maxIndex
    }

    func fetchObjects(query: String) async throws {
        if let objectIds = try await service.getObjectIds(query: query) {
            for (index, objectId) in objectIds.objectIds.enumerated()
            where index < maxIndex {
                if let object = try await service.getObject(
                    objectId: objectId
                ) {
                    objects.append(object)
                }
            }
        }
    }
}
