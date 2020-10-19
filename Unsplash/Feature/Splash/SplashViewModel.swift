//
//  SplashViewModel.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import Foundation
import RxCocoa

class SplashViewModel {
    
    let navToDashboard = BehaviorRelay<Void>(value: ())
    
    init() {
        navigateToDashboard()
    }
    
    func navigateToDashboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self]  in
            self?.navToDashboard.accept(())
        }
    }
    
}
