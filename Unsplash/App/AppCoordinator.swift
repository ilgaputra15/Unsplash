//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let coordinator = SplashCoordinator(window: window)
        return coordinate(to: coordinator)
    }
}
