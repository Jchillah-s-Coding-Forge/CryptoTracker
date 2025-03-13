//
//  PriceData.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct PriceData: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
