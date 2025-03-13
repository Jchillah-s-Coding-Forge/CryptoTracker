//
//  FirestoreService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 13.03.25.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()

    init() {}

    func saveCoin(_ coin: Crypto) async throws {
            let ref = db.collection("coins").document(coin.id)
            try ref.setData(from: coin)
        }


    func getLastUpdatedTime() async throws -> Date? {
        let doc = try await db.collection("meta").document("lastUpdated").getDocument()
        if let timestamp = doc.data()?["timestamp"] as? Timestamp {
            return timestamp.dateValue()
        }
        return nil
    }

    func setLastUpdatedTime() async throws {
        let ref = db.collection("meta").document("lastUpdated")
        try await ref.setData(["timestamp": Timestamp(date: Date())])
    }

    func fetchCoins() async throws -> [Crypto] {
        let snapshot = try await db.collection("coins").getDocuments()
        
        let coins = snapshot.documents.compactMap { doc -> Crypto? in
            try? doc.data(as: Crypto.self)
        }
        
        print("🔍 Firestore enthält \(coins.count) Coins.")
        return coins
    }

//    func fetchCoins() async throws -> [Crypto] {
//        let snapshot = try await db.collection("coins").getDocuments()
//        return snapshot.documents.compactMap { doc in
//            try? doc.data(as: Crypto.self)
//        }
//    }
    
    func addFavoriteCoin(userId: String, coinId: String) async throws {
        let ref = db.collection("users").document(userId)
        try await ref.updateData([
            "favorites": FieldValue.arrayUnion([coinId])
        ])
    }

    func removeFavoriteCoin(userId: String, coinId: String) async throws {
        let ref = db.collection("users").document(userId)
        try await ref.updateData([
            "favorites": FieldValue.arrayRemove([coinId])
        ])
    }

    func getFavoriteCoins(userId: String) async throws -> [String] {
        let doc = try await db.collection("users").document(userId).getDocument()
        return doc.data()?["favorites"] as? [String] ?? []
    }
}
