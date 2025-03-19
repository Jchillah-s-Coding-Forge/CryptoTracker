import SwiftUI
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var newEmail: String = ""
    @Published var newPassword: String = ""
    @Published var updateMessage: String? = nil
    @Published var isLoading: Bool = false

    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    // Aktualisiert den Dark Mode in den Einstellungen.
    func toggleDarkMode() {
        isDarkMode.toggle()
        guard let uid = Auth.auth().currentUser?.uid else {
            updateMessage = "Benutzer nicht gefunden."
            return
        }
        Task {
            do {
                try await SettingsRepository.shared.updateDarkMode(isDarkMode: isDarkMode, for: uid)
            } catch {
                updateMessage = error.localizedDescription
            }
        }
    }
    
    // Aktualisiert die E-Mail-Adresse in Settings und Favorites.
    func updateEmailSetting() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            updateMessage = "Benutzer nicht gefunden."
            return
        }
        isLoading = true
        do {
            // Update in SettingsRepository
            try await SettingsRepository.shared.updateEmail(newEmail: newEmail, for: uid)
            // Update in FavoritesRepository, damit auch dort die E-Mail aktualisiert wird
            try await FavoritesRepository.shared.updateEmail(newEmail: newEmail, for: uid)
            updateMessage = "E-Mail erfolgreich aktualisiert."
        } catch {
            updateMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func updatePassword() async {
        guard let currentUser = Auth.auth().currentUser else {
            updateMessage = "Benutzer nicht gefunden."
            return
        }
        isLoading = true
        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                currentUser.updatePassword(to: newPassword) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
            updateMessage = "Passwort erfolgreich aktualisiert."
        } catch {
            updateMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() async {
        do {
            try AuthService.shared.signOut()
        } catch {
            updateMessage = error.localizedDescription
        }
    }
}
