//
//  DashboardViewModel.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation
import RxRelay
import RxSwift

class DashboardViewModel {
    
    let navToDashboard = BehaviorRelay<Void>(value: ())
    
    let photosData = PublishRelay<[Photo]>()
    let page = BehaviorRelay<Int>(value: 1)
    var photoList: [Photo] = []
    
    let loadMore = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    let search = BehaviorRelay<String>(value: "Tech")
    
    let stateErrorView = BehaviorRelay<Void>(value: ())
    
    init() {
        setup()
        
    }
    
    func setup() {
        
        search.subscribe { (value) in
            self.photoList.removeAll()
            self.page.accept(1)
        }.disposed(by: disposeBag)

        
        
        Observable.combineLatest(search, page)
            .flatMap { (query, page)  in
            return PhotoRepository.shared.getPhotos(query: query, page: page)
            }.subscribe { (response) in
                self.photoList.append(contentsOf: response.results)
                self.photosData.accept(self.photoList)
            } onError: { (error) in
                
            }
            .disposed(by: disposeBag)

        
//        page.subscribe(onNext: { [weak self] page in self?.getPhotos(page: page)})
//            .disposed(by: disposeBag)
        
        
        photosData.subscribe { (photo) in
            print(photo)
        } onError: { (error) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }
        .disposed(by: disposeBag)
        
        loadMore.subscribe { [weak self] (_) in
            if let `self` = self {
                self.page.accept(self.page.value + 1)
            }
        }.disposed(by: disposeBag)

    }
    
    func getPhotos(page: Int) {
        PhotoRepository.shared.getPhotos(query: "office", page: page)
            .subscribe(onSuccess: { [weak self] (photos) in
                if let `self` = self {
                    self.photoList.append(contentsOf: photos.results)
                    self.photosData.accept(self.photoList)
                }
            }, onError: { [weak self] (error) in
                self?.stateErrorView.accept(())
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func navigateToDashboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self]  in
            self?.navToDashboard.accept(())
        }
    }
}
