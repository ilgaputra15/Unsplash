//
//  BaseViewController.swift
//  Unsplash
//
//  Created by Ilga Putra on 20/10/20.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    
    func showLoadingDialog() {
        showLoading {}
    }
        
    func showLoadingDialog(completion: @escaping () -> Void) {
        showLoading(completion: completion)
    }
    
    func hideLoadingDialog() {
        hideLoading {}
    }
    
    func hideLoadingDialog(completion: @escaping () -> Void) {
        hideLoading(completion: completion)
    }

    
    @objc private func showLoading(completion:@escaping ()->Void){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: completion)
        }
    
    @objc private func hideLoading(completion:@escaping () -> Void){
        UIView.animate(withDuration: 1, animations: {}, completion: {isComplete in
            self.dismiss(animated: true, completion: completion)
        })
    }
}
