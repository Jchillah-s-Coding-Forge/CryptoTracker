//
//  AuthViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isRegistering: Bool = false
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        authStateListener = AuthService.shared.addAuthStateListener { [weak self] user in
            self?.currentUser = user
        }
    }
    
    deinit {
        if let handle = authStateListener {
            AuthService.shared.removeAuthStateListener(handle)
        }
    }
    
    func signIn() async {
        errorMessage = nil
        isLoading = true
        do {
            _ = try await AuthService.shared.signIn(email: email, password: password)
            print("Erfolgreich angemeldet als \(email)")
        } catch {
            errorMessage = error.localizedDescription
            print("Fehler beim Anmelden: \(error)")
        }
        isLoading = false
    }
    
    func register() async {
        errorMessage = nil
        isLoading = true
        do {
            _ = try await AuthService.shared.signUp(email: email, password: password)
            print("Registrierung erfolgreich für \(email)")
        } catch {
            errorMessage = error.localizedDescription
            print("Fehler bei der Registrierung: \(error)")
        }
        isLoading = false
    }
    
    func sendPasswordReset() async {
        errorMessage = nil
        isLoading = true
        do {
            try await AuthService.shared.sendPasswordReset(email: email)
            errorMessage = "Passwort-Zurücksetzungs-E-Mail gesendet."
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() async {
        do {
            try AuthService.shared.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
