//
//  Webservice.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation

class Webservice {
    func getBeers(url: URL) async throws -> Beers {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ApiError.invalidServerResponse
        }

        return try JSONDecoder().decode(Beers.self, from: data)
    }
}

enum ApiError: Error {
    case invalidServerResponse
}
