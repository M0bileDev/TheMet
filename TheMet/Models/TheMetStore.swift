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

    init(defaultData: Bool = false) {
        if defaultData {
            objects = initialObjects
        }
    }
    
    func fetchObjects(query: String) async throws{}
}
