//
//  CurrencyFormatter.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import Foundation

struct CurrencyFormatter {
    static func formatPrice(_ price: Double?, currencyCode: String) -> String {
        guard let price = price else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: price)) ?? "\(price) \(currencyCode)"
    }
}
