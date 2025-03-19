//
//  KeychainHelper.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Security
import Foundation

final class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() { }
    
    /// Speichert den API-Key in der iCloud Keychain unter dem angegebenen Account.
    @discardableResult
    func saveAPIKey(_ apiKey: String, for account: String = "NewsAPIKey") -> Bool {
        guard let data = apiKey.data(using: .utf8) else { return false }
        
        // Lösche eventuell vorhandene Einträge für diesen Account, inklusive synchronisierter Daten.
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kCFBooleanTrue as Any
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        // Füge den neuen API-Key hinzu und aktiviere die Synchronisierung.
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrSynchronizable as String: kCFBooleanTrue as Any
        ]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Liest den API-Key aus der iCloud Keychain für den angegebenen Account.
    func getAPIKey(for account: String = "NewsAPIKey") -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecAttrSynchronizable as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            return nil
        }
        return apiKey
    }
    
    /// Löscht den API-Key aus der iCloud Keychain für den angegebenen Account.
    @discardableResult
    func deleteAPIKey(for account: String = "NewsAPIKey") -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kCFBooleanTrue as Any
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
