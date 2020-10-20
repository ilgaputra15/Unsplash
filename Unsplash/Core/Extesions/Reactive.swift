//
//  Reactive.swift
//  Unsplash
//
//  Created by Ilga Putra on 19/10/20.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension Reactive where Base: MoyaProviderType {
    func request<MODEL: Codable>(_ token: Base.Target, _ model: MODEL.Type) -> Single<MODEL> {
        self.printRequest(token)
        return self.request(token)
            .map { response in
                self.printResponse(response)
                return response
            }
            .map(model)
    }
    
    func printResponse(_ response: Response) {
        #if DEBUG
            do {
                let json = try response.mapJSON()
                print("\n--> [\(response.statusCode)] RESPONSE")
                print(json)
            } catch let error {
                print("Error ->  \(error.localizedDescription)")
            }
        #endif
    }
    
    func printRequest(_ token: Base.Target) {
        #if DEBUG
            print("\n--> [\(token.method.rawValue.uppercased())] \(token.baseURL.absoluteString)\(token.path)")
            if let headers = token.headers {
                print("--> HEADER \n \(headers)")
            }
            print("--> PARAM \\ BODY \n\(token.task)")
        #endif
    }
}

public extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let valueY = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return valueY >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        
        return ControlEvent(events: source)
    }
}

