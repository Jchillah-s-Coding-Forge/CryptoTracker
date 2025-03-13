//
//  ChartDuration.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//


import SwiftUI
import Charts

enum ChartDuration: String, CaseIterable, Identifiable {
    case day = "Tag"
    case week = "Woche"
    case month = "Monat"
    case quarter = "Quartal"
    case year = "Jahr"
    
    var id: String { self.rawValue }
    
    var days: Int {
        switch self {
        case .day: return 1
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        }
    }
}
