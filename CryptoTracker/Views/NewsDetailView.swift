//
//  NewsDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(article.title)
                    .font(.largeTitle)
                    .bold()
                if let imageUrl = article.urlToImage, let url = URL(
                    string: imageUrl
                ) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
                if let description = article.description {
                    Text(description)
                        .font(.body)
                }
                Text("Veröffentlicht am: \(article.publishedAt, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                if let url = URL(string: article.url) {
                Link("Weiterlesen", destination: url)
                .font(.headline)
                .padding(.top)
                } else {
                Text("Ungültige URL")
                .font(.headline)
                .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle("News Details")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    let sampleArticle = NewsArticle(
        source: NewsArticle.Source(id: nil, name: "Securityaffairs.com"),
        author: "Pierluigi Paganini",
        title: "Switzerland’s NCSC requires cyberattack reporting for critical infrastructure within 24 hours",
        description: "Switzerland’s NCSC mandates critical infrastructure organizations to report cyberattacks within 24 hours of discovery. Switzerland’s National Cybersecurity Centre (NCSC) now requires critical infrastructure organizations to report cyberattacks within 24 hours…",
        url: "https://securityaffairs.com/175260/laws-and-regulations/switzerlands-ncsc-requires-cyberattack-reporting-for-critical-infrastructure-within-24-hours.html",
        urlToImage: "https://securityaffairs.com/wp-content/uploads/2020/10/swiss-universities-2.jpg",
        publishedAt: ISO8601DateFormatter().date(from: "2025-03-11T19:04:50Z")!,
        content: "Switzerland's NCSC requires cyberattack reporting for critical infrastructure within 24 hours | SideWinder APT targets maritime and nuclear sectors with enhanced toolset | U.S. CISA adds Advantiv… [+146733 chars]"
    )
    
    NewsDetailView(article: sampleArticle)
}

