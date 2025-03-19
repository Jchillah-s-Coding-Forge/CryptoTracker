//
//  FavoritesManager.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 13.03.25.
//

import Foundation
import FirebaseAuth

@MainActor
class FavoritesManager: ObservableObject {
    @Published var favoriteIDs: Set<String> = []
    
    private let repository = FavoritesRepository.shared
    
    var userEmail: String? {
        Auth.auth().currentUser?.email
    }
    
    var userID: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        guard let userID = userID else {
            print("Kein angemeldeter Benutzer oder keine Email gefunden.")
            return
        }
        
        Task {
            do {
                let fetched = try await repository.fetchFavorites(for: userID)
                DispatchQueue.main.async {
                    self.favoriteIDs = fetched
                }
            } catch {
                print("Fehler beim Laden der Favoriten: \(error)")
            }
        }
    }
    
    func toggleFavorite(coin: Crypto) {
        guard let userID = userID, let email = userEmail else {
            print("Kein angemeldeter Benutzer oder keine Email gefunden.")
            return
        }
        
        if favoriteIDs.contains(coin.id) {
            favoriteIDs.remove(coin.id)
        } else {
            favoriteIDs.insert(coin.id)
        }
        persistFavorites(for: userID, email: email)
    }
    
    private func persistFavorites(for userID: String, email: String) {
        Task {
            do {
                try await repository.updateFavorites(favorites: favoriteIDs, for: userID, userEmail: email)
                print("Favoriten wurden gespeichert.")
            } catch {
                print("Fehler beim Speichern der Favoriten: \(error)")
            }
        }
    }
    
    func isFavorite(coin: Crypto) -> Bool {
        favoriteIDs.contains(coin.id)
    }
}
