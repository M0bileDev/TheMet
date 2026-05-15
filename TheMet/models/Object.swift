//
//  Object.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import Foundation

struct Object: Codable, Hashable {
    let objectId: Int
    let title: String
    let creditLine: String
    let objectURL: String
    let isPublicDomain: Bool
    let primaryImageSmall: String
}

struct ObjectIds: Codable {
    let total: Int
    let objectIds: [Int]
}
