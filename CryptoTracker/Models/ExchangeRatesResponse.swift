//
//  ExchangeRatesResponse.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

struct ExchangeRatesResponse: Decodable {
    let rates: [String: ExchangeRate]
}
