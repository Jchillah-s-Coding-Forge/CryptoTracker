//
//  FormatPrice.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

func formatPrice(_ value: Double, currencyCode: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}
