//
//  BaseModel.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation

struct ListResponse<T> : Codable where T: Codable {
    let total: Int
    let totalPages: Int
    var results: [T]
        
    enum CodingKeys: String, CodingKey {
        case results, total
        case totalPages = "total_pages"
    }
}
