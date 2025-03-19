//
//  FavoritesViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteIDs: Set<String> = []
    
    private let favoritesManager = FavoritesManager()
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        favoritesManager.loadFavorites()
        self.favoriteIDs = favoritesManager.favoriteIDs
    }
    
    func toggleFavorite(coin: Crypto) {
        favoritesManager.toggleFavorite(coin: coin)
        self.favoriteIDs = favoritesManager.favoriteIDs
    }
    
    func isFavorite(coin: Crypto) -> Bool {
        favoritesManager.isFavorite(coin: coin)
    }
}
