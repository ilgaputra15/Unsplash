//
//  SplashCoordinator.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import Foundation
import RxSwift

class SplashCoordinator: BaseCoordinator<Void> {
    
    let window: UIWindow
    let viewModel = SplashViewModel()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewController = SplashViewController()
        viewController.viewModel = viewModel
        navigationController = UINavigationController(rootViewController: viewController)
        
        viewModel.navToDashboard
            .subscribe(onNext: { [weak self] in self?.navigateToDashboard()})
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return Observable.never()
    }
    
    func navigateToDashboard() {
        let dashboard = DashboardCoordinator()
        dashboard.navigationController = navigationController
        dashboard.start()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
