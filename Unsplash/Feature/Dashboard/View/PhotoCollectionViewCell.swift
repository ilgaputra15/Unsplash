//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by Ilga Putra on 20/10/20.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var labelLike: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        viewLike.layer.cornerRadius = 4
        viewLike.clipsToBounds = true
    }
    
    func setView(photo: Photo) {
        imageView.setImage(from: photo.urls.regular)
        labelLike.text = "\(photo.likes)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
