//
//  NewsView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Lade News…")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Fehler: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.articles.isEmpty {
                    Text("Keine News verfügbar.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink(destination: NewsDetailView(article: article)) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(article.title)
                                    .font(.headline)
                                if let description = article.description {
                                    Text(description)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Krypto-News")
            .onAppear {
                Task {
                    await viewModel.fetchNews()
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
