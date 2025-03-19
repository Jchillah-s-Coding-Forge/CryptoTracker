//
//  NewsViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let newsService = NewsService()
    
    func fetchNews() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedArticles = try await newsService.fetchNews()
            articles = fetchedArticles
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
