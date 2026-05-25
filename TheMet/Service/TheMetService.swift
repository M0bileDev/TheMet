//
//  TheMetService.swift
//  TheMet
//
//  Created by Damian Ogórek on 25/05/2026.
//

import Foundation

struct TheMetService {
    let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1/"
    let session = URLSession.shared
    let decoder = JSONDecoder()
}
