//
//  ExchangeRatesResponse.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct ExchangeRatesResponse: Decodable {
    let rates: [String: ExchangeRate]
}
