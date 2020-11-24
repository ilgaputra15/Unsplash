//
//  BaseCoordinator.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import Foundation
import UIKit
import RxSwift

protocol CoordinatorProtocol: AnyObject {
    associatedtype ResultType
    typealias CoordinationResult = ResultType
    var navigationController: UINavigationController {get set}
    func start() -> Observable<ResultType>
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T>
    func removeChildCoordinators()
    func didCloseView(_ animated: Bool)
}

class BaseCoordinator<ResultType>: CoordinatorProtocol {
    
    typealias CoordinationResult = ResultType
    var navigationController = UINavigationController()
    let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    
    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }

    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
    
    
    func removeChildCoordinators() {
        self.childCoordinators.forEach { ($0.value as! BaseCoordinator).removeChildCoordinators() }
        self.childCoordinators.removeAll()
    }
    
    func didCloseView(_ animated: Bool) {}
    
    
}
