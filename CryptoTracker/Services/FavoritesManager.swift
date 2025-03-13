//
//  FavoritesManager.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 13.03.25.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteIDs: Set<String> = []
    
    func isFavorite(coin: Crypto) -> Bool {
        favoriteIDs.contains(coin.id)
    }
    
    func toggleFavorite(coin: Crypto) {
        if isFavorite(coin: coin) {
            favoriteIDs.remove(coin.id)
        } else {
            favoriteIDs.insert(coin.id)
        }
    }
}
