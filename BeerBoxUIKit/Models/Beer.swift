//
//  Beer.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 28/02/23.
//

import Foundation

// MARK: - Beer
struct Beer: Codable {
    let id: Int
    let name, tagline, description: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case description
        case imageURL = "image_url"
    }
}

typealias Beers = [Beer]
