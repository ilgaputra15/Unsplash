//
//  DashboardCoordinator.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import Foundation
import RxSwift

class DashboardCoordinator: BaseCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        let viewController = DashboardViewController()
        navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
    
}
