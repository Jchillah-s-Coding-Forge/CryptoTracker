//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct CryptoTrackerApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var cryptoListViewModel = CryptoListViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    /// API-Key erstellen auf https://newsapi.org/
    /// API-Key einfügen, App einmal starten damit wird der API-Key in Keychain gespeichert
    /// API-Key einmal speichern (auskommentiert, wenn nicht mehr benötigt)
    init() {
        //         let saved = KeychainHelper.shared.saveAPIKey("YOUR_API_KEY_HERE")
        //         if saved {
        //             print("API-Key erfolgreich in der Keychain gespeichert.")
        //         } else {
        //             print("Fehler beim Speichern des API-Keys.")
        //         }
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(authViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(cryptoListViewModel)
                .environmentObject(favoritesManager)
                .environmentObject(settingsViewModel)
                .task {
                    // Lade die Dark Mode-Einstellung aus Firestore, falls ein Nutzer angemeldet ist
                    if let userId = Auth.auth().currentUser?.uid {
                        do {
                            let settings = try await SettingsRepository.shared.fetchSettings(for: userId)
                            if let dm = settings["isDarkMode"] as? Bool {
                                isDarkMode = dm
                            }
                        } catch {
                            print("Fehler beim Abrufen der Einstellungen: \(error)")
                        }
                    }
                }
        }
    }
}
