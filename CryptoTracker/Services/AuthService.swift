//
//  AuthService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    
    private init() { }
    
    func signUp(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = authResult?.user {
                    continuation.resume(returning: user)
                }
            }
        }
    }
    
    func signIn(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = authResult?.user {
                    continuation.resume(returning: user)
                }
            }
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func addAuthStateListener(_ listener: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { _, user in
            listener(user)
        }
    }
    
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
