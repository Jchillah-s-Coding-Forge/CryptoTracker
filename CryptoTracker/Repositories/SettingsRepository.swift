//
//  SettingsRepository.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 19.03.25.
//

import Foundation
import FirebaseFirestore

class SettingsRepository {
    static let shared = SettingsRepository()
    private let db = Firestore.firestore()
    
    private init() { }
    
    /// Erzeugt oder aktualisiert das Settings-Dokument für den Nutzer.
    func setSettings(_ settings: [String: Any], for userId: String) async throws {
        try await db.collection("users").document(userId).setData(settings, merge: true)
    }
    
    /// Lädt die Einstellungen für den Nutzer.
    func fetchSettings(for userId: String) async throws -> [String: Any] {
        let document = try await db.collection("users").document(userId).getDocument()
        return document.data() ?? [:]
    }
    
    /// Aktualisiert bestimmte Einstellungen.
    func updateSettings(_ settings: [String: Any], for userId: String) async throws {
        try await db.collection("users").document(userId).updateData(settings)
    }
    
    /// Löscht das gesamte Settings-Dokument des Nutzers.
    func deleteSettings(for userId: String) async throws {
        try await db.collection("users").document(userId).delete()
    }
    
    /// Aktualisiert den Dark Mode-Wert.
    func updateDarkMode(isDarkMode: Bool, for userId: String) async throws {
        try await updateSettings(["isDarkMode": isDarkMode], for: userId)
    }
    
    /// Aktualisiert die E-Mail-Adresse.
    func updateEmail(newEmail: String, for userId: String) async throws {
        try await updateSettings(["email": newEmail], for: userId)
    }
}
