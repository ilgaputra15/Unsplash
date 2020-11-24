//
//  PhotoRepository.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation
import Moya
import RxSwift

class PhotoRepository {
    
    static let shared = PhotoRepository()
    
    private var provider = MoyaProvider<PhotoApi>()
    
    func getPhotos(query: String, page: Int) -> Single<ListResponse<Photo>> {
        return provider.rx.request(.getPhotos(query: query, page: page), ListResponse<Photo>.self)
    }
}
