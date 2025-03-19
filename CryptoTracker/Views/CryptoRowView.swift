//
//  CryptoRowView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import SwiftUI

struct CryptoRowView: View { 
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject var cryptoViewModel: CryptoListViewModel    
    @EnvironmentObject var favoritesManager: FavoritesManager

    let coin: Crypto
    let currency: String

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            } placeholder: {
                ProgressView()
            }
            Text(coin.name)
                .foregroundStyle(Color.priceChangeColor(for: coin.priceChangePercentage24h))
            Spacer()
            Text(CurrencyFormatter.formatPrice(coin.currentPrice, currencyCode: currency.uppercased()))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
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
    CryptoRowView(coin: sampleCrypto, currency: "EUR")
        .environmentObject(AuthViewModel())
        .environmentObject(FavoritesViewModel())
        .environmentObject(CryptoListViewModel())
        .environmentObject(FavoritesManager())
}
