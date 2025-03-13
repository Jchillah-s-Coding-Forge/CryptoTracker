//
//  PriceChartViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
class PriceChartViewModel: ObservableObject {
    @Published var allPriceData: [PriceData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = PriceHistoryService()
    
    func fetchPriceHistory(for coinId: String, vsCurrency: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await service.fetchPriceHistory(for: coinId, vsCurrency: vsCurrency)
            allPriceData = data
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func filteredData(for duration: ChartDuration) -> [PriceData] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -duration.days, to: Date()) ?? Date()
        return allPriceData.filter { $0.date >= cutoffDate }
    }
}

//@MainActor
//class PriceChartViewModel: ObservableObject {
//    @Published var priceData: [PriceData] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    
//    private let service = PriceHistoryService()
//    
//    func fetchPriceHistory(for coinId: String, vsCurrency: String, days: Int = 365) async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            let data = try await service.fetchPriceHistory(for: coinId, vsCurrency: vsCurrency, days: days)
//            priceData = data
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        isLoading = false
//    }
//}
