//
//  PriceHistoryResponse.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct ChartHistoryResponse: Decodable {
    let prices: [[Double]]
}
