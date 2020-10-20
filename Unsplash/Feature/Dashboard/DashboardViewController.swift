//
//  DashboardViewController.swift
//  Unsplash
//
//  Created by Ilga Putra on 17/10/20.
//

import UIKit
import RxCocoa
import RxSwift

class DashboardViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var viewModel: DashboardViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBinding()
    }
    
    func setup() {
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
        collectionView.rx.reachedBottom().bind(to: viewModel.loadMore).disposed(by: disposeBag)
    }

}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 10) / 2 // compute your cell width
            return CGSize(width: cellWidth, height: cellWidth / 0.5)
        }
    
    
}
