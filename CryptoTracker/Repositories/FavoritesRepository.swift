//
//  FavoritesRepository.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import Foundation
import FirebaseFirestore

class FavoritesRepository {
    static let shared = FavoritesRepository()
    private let db = Firestore.firestore()
    
    private init() { }
    
    // Fügt einen einzelnen Favoriten hinzu (als Dictionary)
    func addFavorite(coinId: String, for userId: String, userEmail: String) async throws {
        let newFavorite: [String: Any] = [
            "email": userEmail,
            "coinId": coinId
        ]
        try await db.collection("users").document(userId).updateData([
            "favorites": FieldValue.arrayUnion([newFavorite])
        ])
    }
    
    // Aktualisiert das gesamte Favoriten-Array (ersetzt vorhandene Einträge)
    func updateFavorites(favorites: Set<String>, for userId: String, userEmail: String) async throws {
        let favoritesArray = favorites.map { coinId in
            return ["email": userEmail, "coinId": coinId]
        }
        try await db.collection("users").document(userId).setData([
            "favorites": favoritesArray,
            "email": userEmail
        ], merge: true)
    }
    
    // Aktualisiert die im Dokument gespeicherte E-Mail-Adresse
    func updateEmail(newEmail: String, for userId: String) async throws {
        try await db.collection("users").document(userId).updateData([
            "email": newEmail
        ])
    }
    
    // Lädt das Favoriten-Array und extrahiert die Coin-IDs
    func fetchFavorites(for userId: String) async throws -> Set<String> {
        let document = try await db.collection("users").document(userId).getDocument()
        if let data = document.data(),
           let favArray = data["favorites"] as? [[String: Any]] {
            let coinIds = favArray.compactMap { $0["coinId"] as? String }
            return Set(coinIds)
        }
        return []
    }
    
    // Löscht das gesamte Favoriten-Feld
    func deleteFavorites(for userId: String) async throws {
        try await db.collection("users").document(userId).updateData(["favorites": FieldValue.delete()])
    }
}
