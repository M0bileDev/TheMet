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

    func getObjectIds(query: String) async throws -> ObjectIDs? {
        if query.isEmpty {
            return nil
        }
            
        let objectIds: ObjectIDs?

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

        let (data, response) = try await session.data(for: request)

        guard let httpUrlResponse = response as? HTTPURLResponse else {
            print("getObjectIDs: response is not HTTPURLResponse")
            return nil
        }

        guard (200..<300).contains(httpUrlResponse.statusCode) else {
            print(
                "getObjectIDs incorrect, status code: \(httpUrlResponse.statusCode)"
            )
            return nil
        }

        do {
            objectIds = try decoder.decode(ObjectIDs.self, from: data)
        } catch {
            print("Decoder error: \(error)")
            return nil
        }

        return objectIds
    }

    func getObject(objectId: Int) async throws -> Object? {
        let object: Object?
        let objectsPath = "objects/"
        let objectQuery = "\(objectId)"

        guard let objectURL = URL(string: baseURL + objectsPath + objectQuery)
        else { return nil }
        let objectRequest = URLRequest(url: objectURL)

        let (data, response) = try await session.data(for: objectRequest)

        guard let httpUrlResponse = response as? HTTPURLResponse else {
            print("getObject: response is not HTTPURLResponse")
            return nil
        }

        guard (200..<300).contains(httpUrlResponse.statusCode) else {
            print(
                "getObject incorrect, status code: \(httpUrlResponse.statusCode)"
            )
            return nil
        }

        do {
            object = try decoder.decode(Object.self, from: data)
        } catch {
            print("Decoder error: \(error)")
            return nil
        }

        return object
    }
}
