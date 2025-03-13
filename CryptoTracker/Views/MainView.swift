//
//  MainView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: CryptoListViewModel = .init()
    @StateObject var favoritesManager: FavoritesManager = .init()
    
    var body: some View {
        TabView {
            CryptoListView()
                .tabItem {
                    Label("Top Coins", systemImage: "bitcoinsign.circle.fill")
                }
            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "star.fill")
                }
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
        }
        .environmentObject(viewModel)
        .environmentObject(favoritesManager)
    }
}

#Preview {
    MainView()
}
