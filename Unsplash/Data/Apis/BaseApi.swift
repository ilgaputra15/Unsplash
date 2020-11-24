//
//  BaseApi.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation
import Moya

protocol BaseApi: TargetType {}

extension BaseApi {
    var baseHeaders: [String: String]? {
        return ["Content-Type": "application/json", "Authorization": BuildConfig.token.rawValue]
    }
    
    var baseUrl: String {
        return BuildConfig.baseURL.rawValue
    }
    
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return baseHeaders
    }
}
