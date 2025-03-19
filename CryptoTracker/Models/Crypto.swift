//
//  Crypto.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct Crypto: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    var currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int
    var volume: Double
    let high24h: Double
    let low24h: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case volume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case lastUpdated = "last_updated"
    }
}

