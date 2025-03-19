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
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Lade News…")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Fehler: \(errorMessage)")
                        .foregroundStyle(.red)
                } else if viewModel.articles.isEmpty {
                    Text("Keine News verfügbar.")
                        .foregroundStyle(.gray)
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
                                        .foregroundStyle(.gray)
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
