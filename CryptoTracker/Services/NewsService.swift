//
//  NewsService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

class NewsService {
    private let baseURL = "https://newsapi.org/v2/everything"
    
    // Der API-Key wird aus der iCloud Keychain abgerufen.
    private var apiKey: String? {
        return KeychainHelper.shared.getAPIKey()
    }
    
    func fetchNews() async throws -> [NewsArticle] {
        guard let apiKey = apiKey else {
            throw NSError(domain: "NewsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "API-Key nicht gefunden"])
        }
        
        let query = "cryptocurrency"
        let urlString = "\(baseURL)?q=\(query)&sortBy=publishedAt&language=en&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        struct NewsAPIResponse: Decodable {
            let status: String
            let totalResults: Int
            let articles: [NewsArticle]
        }
        
        let apiResponse = try decoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles
    }
}
