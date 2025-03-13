//
//  FavoritesView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var viewModel: CryptoListViewModel
    @State private var favoritesCurrency: String = "usd"
    
    var conversionFactor: Double {
        viewModel.conversionFactor(for: favoritesCurrency)
    }
    
    var favoriteCoins: [Crypto] {
        viewModel.allOriginalCoins.filter { favoritesManager.favoriteIDs.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !favoriteCoins.isEmpty {
                    Picker("Währung", selection: $favoritesCurrency) {
                        ForEach(["usd", "eur", "gbp"], id: \.self) { currency in
                            Text(currency.uppercased()).tag(currency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                Group {
                    if favoriteCoins.isEmpty {
                        Text("Keine Favoriten vorhanden.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(favoriteCoins) { coin in
                            NavigationLink(
                                destination: CryptoDetailView(
                                    coin: coin,
                                    currency: favoritesCurrency,
                                    applyConversion: true
                                )
                                .environmentObject(viewModel)
                            ) {
                                HStack {
                                    AsyncImage(url: URL(string: coin.image)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text(coin.name)
                                    Spacer()
                                    Text(formatPrice(coin.currentPrice * conversionFactor, currencyCode: favoritesCurrency.uppercased()))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Favoriten")
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager())
        .environmentObject(CryptoListViewModel())
}
