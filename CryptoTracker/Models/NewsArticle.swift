//
//  NewsArticle.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct NewsArticle: Identifiable, Decodable {
    var id: String { url }
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
    struct Source: Decodable {
        let id: String?
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}
