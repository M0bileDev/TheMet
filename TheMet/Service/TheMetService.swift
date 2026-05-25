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

    func getObjectIds(query: String) async throws -> ObjectIds? {
        let objectIds: ObjectIds?

        guard
            var urlComponents = URLComponents(string: baseURL + "search")
        else {
            return nil
        }

        let parameters = ["hasImages": "true"]
        urlComponents.setQueryItems(parameters: parameters)
        urlComponents.queryItems! += [URLQueryItem(name: "q", value: query)]

        guard let url = urlComponents.url else { return nil }
        let request = URLRequest(url: url)

        return nil
    }

    func getObject(objectId: Int) async throws -> Object? {
        return nil
    }
}
