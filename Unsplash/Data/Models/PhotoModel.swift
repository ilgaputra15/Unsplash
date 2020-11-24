//
//  PhotoModel.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation

struct Photo: Codable {
    let id: String
    let createdAt: String
    let color: String
    let urls: PhotoUrl
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id, color, urls, likes
        case createdAt = "created_at"
    }
}

struct PhotoUrl: Codable {
    let raw: String
    let regular: String
}
