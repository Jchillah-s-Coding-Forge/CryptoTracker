//
//  CryptoService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

class CryptoService {
    private let coinDataURLBase = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="
    private let exchangeRatesURL = "https://api.coingecko.com/api/v3/exchange_rates"
    
    private var exchangeRates: [String: Double] = [:]
    
    func fetchCryptoData(for currency: String) async throws -> [Crypto] {
        let urlString = "\(coinDataURLBase)\(currency)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            if httpResponse.statusCode == 429 {
                print("⚠️ API-Limit erreicht (429). Wartezeit empfohlen.")
                throw NSError(domain: "CryptoService", code: 429, userInfo: [NSLocalizedDescriptionKey: "Abfrage-Limit erreicht, bitte versuchen Sie es in einer Minute erneut."])
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode([Crypto].self, from: data)
        } catch {
            if let urlError = error as? URLError, urlError.code == .badServerResponse {
                throw NSError(domain: "CryptoService", code: -1011, userInfo: [NSLocalizedDescriptionKey: "Abfrage-Limit erreicht, bitte versuchen Sie es in einer Minute erneut."])
            }
            throw error
        }
    }
    
    func fetchExchangeRates() async throws {
        guard let url = URL(string: exchangeRatesURL) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            if httpResponse.statusCode == 429 {
                print("⚠️ API-Limit erreicht (429). Wartezeit empfohlen.")
                throw NSError(domain: "CryptoService", code: 429, userInfo: [NSLocalizedDescriptionKey: "Abfrage-Limit erreicht, bitte versuchen Sie es in einer Minute erneut."])
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let ratesResponse = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
            exchangeRates = ratesResponse.rates.mapValues { $0.value }
        } catch {
            throw error
        }
    }
    
    func getConversionRate(for currency: String) -> Double {
        return exchangeRates[currency.lowercased()] ?? 1.0 
    }
}
