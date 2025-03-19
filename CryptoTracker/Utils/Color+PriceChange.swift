//
//  Color+PriceChange.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import SwiftUI

extension Color {
    static func priceChangeColor(for change: Double) -> Color {
        if change < 0 {
            return .red
        } else if change > 0 {
            return .green
        } else {
            return .primary
        }
    }
}
