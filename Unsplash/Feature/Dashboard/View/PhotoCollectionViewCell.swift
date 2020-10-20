//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by Ilga Putra on 20/10/20.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setView(photo: Photo) {
        imageView.setImage(from: photo.urls.regular)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
