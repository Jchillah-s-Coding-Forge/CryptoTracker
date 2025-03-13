//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoListView: View {
    @StateObject private var viewModel = CryptoListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.statusMessage)
                    .foregroundColor(viewModel.statusMessage.contains("Fehler") ? .red : .gray)
                    .padding()
                
                Picker("Währung", selection: $viewModel.selectedCurrency) {
                    ForEach(["usd", "eur", "gbp"], id: \.self) { currency in
                        Text(currency.uppercased()).tag(currency)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: viewModel.selectedCurrency) { oldValue, newValue in
                    print("Währung geändert von \(oldValue) zu \(newValue)")
                    Task {
                        await viewModel.fetchCoins()
                        viewModel.applyConversionRate()
                    }
                }
                
                if viewModel.coins.isEmpty {
                    Text("Keine Daten verfügbar.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.coins) { coin in
                        NavigationLink(destination: CryptoDetailView(coin: coin)
                                        .environmentObject(viewModel)) {
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
                                Text(formatPrice(coin.currentPrice, currencyCode: viewModel.selectedCurrency.uppercased()))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.fetchCoins()
                    }
                }
            }
            .navigationTitle("Krypto-Preise")
        }
    }
}

#Preview {
    CryptoListView()
}
