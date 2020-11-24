//
//  DashboardViewController.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import UIKit
import RxCocoa
import RxSwift

class DashboardViewController: BaseViewController {
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: DashboardViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBinding()
    }
    
    func setup() {
        navigationItem.hidesSearchBarWhenScrolling = false
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }
    
    func setupBinding() {
        searchBar.rx.text.orEmpty
            .filter { query in return query.count > 2 }
            .debounce(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.search).disposed(by: disposeBag)
        
        viewModel.photosData.bind(to: collectionView.rx.items(cellIdentifier: "PhotoCollectionViewCell", cellType: PhotoCollectionViewCell.self)) {row,photo,cell in
            cell.setView(photo: photo)
        }.disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom()
            .bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        viewModel.photosData
            .map { (photo) in !photo.isEmpty}
            .bind(to: labelEmpty.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.stateLoadingView.subscribe(onNext: { [weak self] isShow in
            if isShow {
                self?.showLoadingDialog()
            } else {
                self?.hideLoadingDialog()
            }
        }).disposed(by: disposeBag)
        
        viewModel.stateErrorView.subscribe(onNext: {[weak self] error in
            self?.hideLoadingDialog {
                self?.error(message: error)
            }
        }).disposed(by: disposeBag)
    }
    
    func error(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert,animated: true,completion: nil)
    }

}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 56) / 2
            return CGSize(width: cellWidth, height: cellWidth / 0.7)
        }
}

