//
//  MainView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CryptoListViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @EnvironmentObject private var favoritesManager: FavoritesManager
    
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
                .environmentObject(favoritesViewModel)

            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .environmentObject(authViewModel)
                .environmentObject(viewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(favoritesManager)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
        .environmentObject(CryptoListViewModel())
        .environmentObject(FavoritesViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(FavoritesManager())
}
