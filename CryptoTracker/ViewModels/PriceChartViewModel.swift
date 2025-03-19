//
//  PriceChartViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
class PriceChartViewModel: ObservableObject {
    @Published var allPriceData: [ChartData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedCurrency: String = "usd" {
        didSet {
            applyConversionRate()
        }
    }
    
    var conversionRates: [String: Double] = ["usd": 1.0, "eur": 0.92, "gbp": 0.78]
    
    private let service = ChartDataService()
    
    func fetchPriceHistory(for coinId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await service.fetchChartData(
                for: coinId,
                vsCurrency: "usd"
            )
            allPriceData = data
            applyConversionRate() 
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func filteredData(for duration: ChartDuration) -> [ChartData] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -duration.days, to: Date()) ?? Date()
        return allPriceData.filter { $0.date >= cutoffDate }
    }
    
    func conversionFactor() -> Double {
        let baseRate = conversionRates["usd"] ?? 1.0
        let targetRate = conversionRates[selectedCurrency.lowercased()] ?? 1.0
        return targetRate / baseRate
    }
    
    func applyConversionRate() {
        let factor = conversionFactor()
        allPriceData = allPriceData.map { ChartData(date: $0.date, price: $0.price * factor) }
    }
}
