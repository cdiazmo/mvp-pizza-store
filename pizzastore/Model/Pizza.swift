//
//  Pizza.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import Foundation

// MARK: - Welcome
struct Pizza: Identifiable, Codable {
    let id: Int
    let name, content: String
    let imageURL: String
    let prices: [Price]

    enum CodingKeys: String, CodingKey {
        case id, name, content
        case imageURL = "imageUrl"
        case prices
    }
}

// MARK: - Price
struct Price: Codable {
    let size: String
    let price: Double
}
