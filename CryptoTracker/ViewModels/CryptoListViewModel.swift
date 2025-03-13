//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation
import FirebaseFirestore

@MainActor
class CryptoListViewModel: ObservableObject {
    @Published var conversionRates: [String: Double] = ["usd": 1.0, "eur": 0.92, "gbp": 0.78]
    @Published var coins: [Crypto] = []
    @Published var favoriteCoins: [String] = []
    @Published var statusMessage: String = "Laden…"
    @Published var selectedCurrency: String = "usd" {
        didSet {
            applyConversionRate()
        }
    }
    
    private let baseCurrency: String = "usd"
    private let cryptoService = CryptoService()
    private let firestoreService = FirestoreService()
    private var lastFetchedAt: Date? = nil
    private var originalCoins: [Crypto] = []
    private let throttleInterval: TimeInterval = 60
    
    var allOriginalCoins: [Crypto] {
        return originalCoins
    }
    
    init() {
        Task {
            await fetchExchangeRates()
            await fetchCoins()
            startTimer()
        }
    }
    
    /// **Lädt Coins aus Firestore und konvertiert die Preise in die ausgewählte Währung.**
    func fetchCoinsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("cryptos")
            .order(by: "marketCapRank") // Sortiere nach Rang, oder passe das Attribut an
            .getDocuments { snapshot, error in
            if let error = error {
                print("❌ Fehler beim Laden der Coins: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.main.async {
                self.originalCoins = documents.compactMap { doc -> Crypto? in
                    do {
                        var coin = try doc.data(as: Crypto.self)
                        
                        // Währungsumrechnung
                        let factor = self.conversionFactor(for: self.selectedCurrency)
                        coin.currentPrice *= factor
                        coin.marketCap *= factor
                        coin.volume *= factor
                        coin.high24h *= factor
                        coin.low24h *= factor
                        
                        return coin
                    } catch {
                        print("⚠️ Fehler beim Dekodieren: \(error)")
                        return nil
                    }
                }
                
                self.applyConversionRate()
            }
        }
    }
    
    func fetchCoins() async {
        do {
            if let lastUpdated = try await firestoreService.getLastUpdatedTime(),
               Date().timeIntervalSince(lastUpdated) < throttleInterval {
                statusMessage = "Daten aus Firestore geladen."
                coins = try await firestoreService.fetchCoins()
                applyConversionRate() // 🔹 Umrechnung nach Firestore-Datenabruf
                return
            }

            statusMessage = "Lade neue Daten…"
            let fetchedCoins = try await cryptoService.fetchCryptoData(for: baseCurrency)

            for coin in fetchedCoins {
                try await firestoreService.saveCoin(coin)
            }

            try await firestoreService.setLastUpdatedTime()
            originalCoins = fetchedCoins
            applyConversionRate() // 🔹 Umrechnung nach API-Datenabruf
            statusMessage = "Daten aktualisiert."
        } catch {
            statusMessage = "Fehler: \(error.localizedDescription)"
        }
    }
    
    func fetchExchangeRates() async {
        do {
            try await cryptoService.fetchExchangeRates()
        } catch {
            print("Fehler beim Abrufen der Wechselkurse: \(error)")
        }
    }
    
    // **Konvertiert die bereits geladenen Coins in die aktuelle Währung.**
    func applyConversionRate() {
        let factor = conversionFactor(for: selectedCurrency)
        coins = originalCoins.map { coin in
            Crypto(
                id: coin.id,
                symbol: coin.symbol,
                name: coin.name,
                image: coin.image,
                currentPrice: coin.currentPrice * factor,
                marketCap: coin.marketCap * factor,
                marketCapRank: coin.marketCapRank,
                volume: coin.volume * factor,
                high24h: coin.high24h * factor,
                low24h: coin.low24h * factor,
                priceChange24h: coin.priceChange24h * factor,
                priceChangePercentage24h: coin.priceChangePercentage24h,
                lastUpdated: coin.lastUpdated
            )
        }
    }
    
//    func applyConversionRate() {
//        let baseRate = cryptoService.getConversionRate(for: baseCurrency)
//        let targetRate = cryptoService.getConversionRate(for: selectedCurrency)
//        let conversionFactor = targetRate / baseRate
//        
//        coins = originalCoins.map { coin in
//            return Crypto(
//                id: coin.id,
//                symbol: coin.symbol,
//                name: coin.name,
//                image: coin.image,
//                currentPrice: coin.currentPrice * conversionFactor,
//                marketCap: coin.marketCap * conversionFactor,
//                marketCapRank: coin.marketCapRank,
//                volume: coin.volume * conversionFactor,
//                high24h: coin.high24h * conversionFactor,
//                low24h: coin.low24h * conversionFactor,
//                priceChange24h: coin.priceChange24h * conversionFactor,
//                priceChangePercentage24h: coin.priceChangePercentage24h,
//                lastUpdated: coin.lastUpdated
//            )
//        }
//    }
    
    func conversionFactor(for currency: String) -> Double {
        return conversionRates[currency] ?? 1.0
    }

    func formattedPrice(for coin: Crypto) -> String {
        return formatPrice(coin.currentPrice, currencyCode: selectedCurrency.uppercased())
    }
    
    private func shouldFetch() -> Bool {
        if let lastFetch = lastFetchedAt {
            return Date().timeIntervalSince(lastFetch) > throttleInterval
        }
        return true
    }
    
    private func startTimer() {
        Task {
            while true {
                try await Task.sleep(nanoseconds: UInt64(throttleInterval * 1_000_000_000))
                await fetchCoins()
            }
        }
    }
    
    func loadFavorites(userId: String) async {
        do {
            favoriteCoins = try await firestoreService.getFavoriteCoins(userId: userId)
        } catch {
            print("❌ Fehler beim Laden der Favoriten: \(error.localizedDescription)")
        }
    }
    
    func toggleFavorite(userId: String, coinId: String) async {
        if favoriteCoins.contains(coinId) {
            try? await firestoreService.removeFavoriteCoin(userId: userId, coinId: coinId)
            favoriteCoins.removeAll { $0 == coinId }
        } else {
            try? await firestoreService.addFavoriteCoin(userId: userId, coinId: coinId)
            favoriteCoins.append(coinId)
        }
    }
}
