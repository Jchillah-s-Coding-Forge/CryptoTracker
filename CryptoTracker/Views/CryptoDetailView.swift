//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoDetailView: View {
    let coin: Crypto
    var currency: String? = nil
    var applyConversion: Bool = false
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewModel: CryptoListViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var faoritesViewModel: FavoritesViewModel
    
    var body: some View {
        let detailVM = CryptoDetailViewModel(coin: coin, viewModel: viewModel, currency: currency, applyConversion: applyConversion)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Preis: \(CurrencyFormatter.formatPrice(detailVM.effectivePrice, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                    .font(.title2)
                    .foregroundStyle(.gray)
                Text("Marktkapitalisierung: \(CurrencyFormatter.formatPrice(detailVM.effectiveMarketCap, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                    .font(.body)
                Text("24-Stunden-Handelsvolumen: \(CurrencyFormatter.formatPrice(detailVM.effectiveVolume, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                    .font(.body)
                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
                    .foregroundStyle(Color.priceChangeColor(for: coin.priceChangePercentage24h))
                    .font(.body)
                Text("24-Stunden-Höchstpreis: \(CurrencyFormatter.formatPrice(detailVM.effectiveHigh24h, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                Text("24-Stunden-Tiefstpreis: \(CurrencyFormatter.formatPrice(detailVM.effectiveLow24h, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                
                // Chart anzeigen
                PriceChartView(coinId: coin.id, vsCurrency: detailVM.effectiveCurrency)
                
                Button(action: {
                    favoritesManager.toggleFavorite(coin: coin)
                }) {
                    let isFavorite = favoritesManager.isFavorite(coin: coin)
                    HStack {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                        Text(isFavorite ? "Aus Favoriten entfernen" : "Zu Favoriten hinzufügen")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(coin.name)
    }
}

#Preview {
    let sampleCrypto = Crypto(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 76797,
        marketCap: 1510872859579,
        marketCapRank: 1,
        volume: 221212,
        high24h: 77286,
        low24h: 72691,
        priceChange24h: 2291.17,
        priceChangePercentage24h: 3.07518,
        lastUpdated: "2025-03-12T13:36:39.814Z"
    )
    CryptoDetailView(coin: sampleCrypto, currency: "eur", applyConversion: true)
        .environmentObject(CryptoListViewModel())
        .environmentObject(FavoritesManager())
        .environmentObject(SettingsViewModel())
        .environmentObject(FavoritesManager())
}
