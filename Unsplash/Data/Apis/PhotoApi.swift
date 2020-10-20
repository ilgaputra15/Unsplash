//
//  PhotoApi.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation
import Moya

enum PhotoApi {
    case getPhotos(query: String, page: Int)
}

extension PhotoApi: BaseApi {
    
    var path: String {
        switch self {
        case .getPhotos:
            return "search/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPhotos:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        switch self {
        case .getPhotos(let query, let page):
            param["query"] = query
            param["page"] = page
        }
        return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
    }
}
