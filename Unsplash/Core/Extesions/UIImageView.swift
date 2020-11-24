//
//  UIImageView.swift
//  Unsplash
//
//  Created by Ilga Putra on 20/10/20.
//

import UIKit

let imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    
    func setImage(from url: URL, error defaultImage: UIImage? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFill, success onSuccess: @escaping () -> Void = {}) {
        
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        view.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addSubview(view)
        
        self.contentMode = mode
        self.image = defaultImage
        if let cacheImage = imageCache.object(forKey: url.absoluteString as NSString){
            self.backgroundColor = UIColor.clear
            self.image = cacheImage
            view.isHidden = true
            onSuccess()
            return
        }
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                        return
                }
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async() {
                    self.backgroundColor = UIColor.clear
                    self.contentMode = mode
                    self.image = image
                    view.isHidden = true
                    onSuccess()
                }
                }.resume()
        }
    }
    func setImage(from link: String, error defaultImage: UIImage? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFill, onSuccess: @escaping () -> Void = {}) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        if defaultImage == nil {
            self.backgroundColor = UIColor.whisper
        }
        self.contentMode = mode
        self.image = defaultImage
        guard let url = URL(string: link) else { return }
        setImage(from: url, error: defaultImage, contentMode: mode, success: onSuccess)
    }

}
