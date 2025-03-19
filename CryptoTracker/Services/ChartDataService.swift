//
//  PriceHistoryService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

class ChartDataService {
    
    func fetchChartData(for coinId: String, vsCurrency: String) async throws -> [ChartData] {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinId)/market_chart?vs_currency=\(vsCurrency)&days=365"
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
                throw NSError(domain: "ChartDataService", code: 429, userInfo: [NSLocalizedDescriptionKey: "Abfrage-Limit erreicht, bitte versuchen Sie es in einer Minute erneut."])
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            saveDataToLocalJSON(data: data, for: coinId, vsCurrency: vsCurrency)
            return try parseChartData(data)
        } catch {
            if let localData = loadLocalJSON(for: coinId, vsCurrency: vsCurrency) {
                do {
                    return try parseChartData(localData)
                } catch {
                    print("Fehler beim Parsen der lokalen JSON-Daten: \(error)")
                }
            }
            if let urlError = error as? URLError, urlError.code == .badServerResponse {
                throw NSError(domain: "ChartDataService", code: -1011, userInfo: [NSLocalizedDescriptionKey: "Abfrage-Limit erreicht, bitte versuchen Sie es in einer Minute erneut."])
            }
            print("Kein lokaler Cache verfügbar. Rückgabe eines leeren Arrays. Fehler: \(error)")
            return []
        }
    }
    
    private func parseChartData(_ data: Data) throws -> [ChartData] {
        let decoder = JSONDecoder()
        let historyResponse = try decoder.decode(ChartHistoryResponse.self, from: data)
        let priceData: [ChartData] = historyResponse.prices.compactMap { array in
            guard array.count >= 2 else { return nil }
            let timestamp = array[0]
            let price = array[1]
            let date = Date(timeIntervalSince1970: timestamp / 1000)
            return ChartData(date: date, price: price)
        }
        return priceData
    }
    
    private func localFileURL(for coinId: String, vsCurrency: String) -> URL {
        let fileName = "\(coinId)_\(vsCurrency)_365.json"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(fileName)
    }
    
    private func saveDataToLocalJSON(data: Data, for coinId: String, vsCurrency: String) {
        let fileURL = localFileURL(for: coinId, vsCurrency: vsCurrency)
        do {
            try data.write(to: fileURL)
        } catch {
            print("Fehler beim Speichern der lokalen JSON: \(error)")
        }
    }
    
    private func loadLocalJSON(for coinId: String, vsCurrency: String) -> Data? {
        let fileURL = localFileURL(for: coinId, vsCurrency: vsCurrency)
        return try? Data(contentsOf: fileURL)
    }
}
