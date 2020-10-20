//
//  DashboardViewModel.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation
import RxRelay
import RxSwift

class DashboardViewModel: BaseViewModel {
    
    let photosData = PublishRelay<[Photo]>()
    let page = BehaviorRelay<Int>(value: 1)
    var photoList: [Photo] = []
    
    let loadMore = PublishRelay<Void>()
    let search = BehaviorRelay<String>(value: "Tech")
    
    let stateErrorView = PublishRelay<String>()
    let stateLoadingView = BehaviorRelay<Bool>(value: false)
    
    override init() {
        super.init()
        setup()
    }

    func setup() {
        search.subscribe{ [weak self] (value) in
            if let `self` = self {
                self.photoList.removeAll()
                self.stateLoadingView.accept(true)
                self.page.accept(1)
            }
        }.disposed(by: disposeBag)
        
        page.flatMap { (page) in
            PhotoRepository.shared.getPhotos(query: self.search.value, page: page)
        }.subscribe { [weak self] (response) in
            if let `self` = self {
                self.photoList.append(contentsOf: response.results)
                self.photosData.accept(self.photoList)
                self.stateLoadingView.accept(false)
            }
        } onError: { [weak self] (error) in
            self?.stateErrorView.accept(error.localizedDescription)
        }.disposed(by: disposeBag)

        loadMore.subscribe { [weak self] (_) in
            if let `self` = self {
                self.page.accept(self.page.value + 1)
            }
        }.disposed(by: disposeBag)

    }
}
