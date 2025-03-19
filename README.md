# CryptoTracker

CryptoTracker ist eine iOS-App, die es Benutzern ermöglicht, Kryptowährungen in Echtzeit zu verfolgen, Preischarts zu analysieren und favorisierte Coins zu speichern. Die App nutzt **Firebase** zur Benutzerauthentifizierung und **Firestore** zur Speicherung von Favoriten sowie **Keychain** für sichere API-Schlüssel.

## Features
- **Echtzeit-Kryptodaten**: Anzeige aktueller Preise und Marktdaten
- **Preisdiagramme**: Historische Preisdaten in interaktiven Charts
- **Favoriten speichern**: Nutzer können Coins als Favoriten markieren
- **Benutzerauthentifizierung**: Sign-In/Sign-Up mit Firebase
- **API-Schlüssel sicher speichern**: Keychain zur sicheren Speicherung des API-Keys

## Klassendiagramme

### CryptoListViewModel

![Klassendiagramm des CryptoListViewModel](Screenshots/KlassendiagrammCryptoListViewModel.png)

### FavoritesView und FavoritesManager

![Klassendiagramm der FavoritesView und des FavoritesManager](Screenshots/KlassendiagrammFavoritesViewUndFavoritesManager.png)

## Klassendiagramme

### CryptoListViewModel

<div align="center">
  <img src="Screenshots/KlassendiagrammCryptoListViewModel.png" alt="Klassendiagramm des CryptoListViewModel">
</div>

### FavoritesView und FavoritesManager

<div align="center">
  <img src="Screenshots/KlassendiagrammFavoritesViewUndFavoritesManager.png" alt="Klassendiagramm der FavoritesView und des FavoritesManager">
</div>

## Installation
### Voraussetzungen
1. **Xcode** installieren (aktuelle Version empfohlen)
2. **CocoaPods** installieren (falls nicht vorhanden):
   ```bash
   sudo gem install cocoapods
   ```
3. **Firebase-Setup**:
   - Erstelle ein Firebase-Projekt auf [Firebase Console](https://console.firebase.google.com/)
   - Lade die `GoogleService-Info.plist` herunter und lege sie im Xcode-Projekt ab
   
4. **API-Key generieren**:
   - Registriere dich auf [CoinGecko](https://www.coingecko.com/) oder einer ähnlichen API-Plattform
   - Speichere den API-Key sicher in der Keychain:
     ```swift
     let keychain = Keychain()
     try? keychain.set("DEIN_API_KEY", key: "CryptoAPIKey")
     ```

### Projekt einrichten
1. Repository klonen:
   ```bash
   git clone https://github.com/jchillah/CryptoTracker.git
   cd CryptoTracker
   ```
2. Abhängigkeiten installieren:
   ```bash
   pod install
   ```
3. Projekt in Xcode öffnen:
   ```bash
   open CryptoTracker.xcworkspace
   ```
4. App starten:
   - Wähle ein iOS-Simulator- oder physisches Gerät
   - Klicke auf **Run (▶)** in Xcode

## Verzeichnisstruktur
```
CryptoTracker/
├── CryptoTrackerApp.swift  # Haupt-App Datei
├── Views/                 # SwiftUI Views
├── ViewModels/            # MVVM ViewModels
├── Services/              # API & Firestore Services
├── Models/                # Datenmodelle
├── Utils/                 # Hilfsfunktionen
├── Resources/             # Assets, GoogleService-Info.plist
└── README.md              # Projektdokumentation
```

## Lizenz
ohne Lizenz
