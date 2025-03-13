//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI
import Firebase

@main
struct CryptoTrackerApp: App {
    /// After you saved your API Key, you can outcomment this Code like now
    init() {
        /// Just run this Code once to save your API-Key in KeyChain
        /// Replace "YourRealAPIKeyHere" with your real API-Key.
//        let saved = KeychainHelper.shared.saveAPIKey("YOUR_REAL_API_KEY_HERE")
//        if saved {
//            print("API-Key erfolgreich in der Keychain gespeichert.")
//        } else {
//            print("Fehler beim Speichern des API-Keys.")
//        }
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
