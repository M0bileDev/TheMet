//
//  TheMetStore.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import Combine
import Foundation

//class TheMetStore: ObservableObject {
//  @Published var objects: [Object] = []
//
//  init() {
//    #if DEBUG
//    createDevData()
//    #endif
//  }
//}

class TheMetStore: ObservableObject {
    @Published var objects: [Object] = []

    init(defaultData: Bool = false) {
        if defaultData {
            objects = initialObjects
        }
    }
}
