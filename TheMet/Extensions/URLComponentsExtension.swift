//
//  URLComponentsExtension.swift
//  TheMet
//
//  Created by Damian Ogórek on 25/05/2026.
//

import Foundation

extension URLComponents {
    public mutating func setQueryItems(parameters: [String: String]) {
        self.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
