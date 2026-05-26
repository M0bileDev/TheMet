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

    func fetchObjects(query: String) async throws {}
}
