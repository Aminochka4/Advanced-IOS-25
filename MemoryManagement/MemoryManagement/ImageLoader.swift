//
//  ImageLoader.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 17.02.2025.
//

import UIKit

protocol ImageLoaderDelegate: AnyObject {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage)
    func imageLoader(_ loader: ImageLoader, didFailWith error: Error)
}

class ImageLoader {
    weak var delegate: ImageLoaderDelegate?
    var completionHandler: ((UIImage?) -> Void)?
    
    func loadImage(url: URL) {
        DispatchQueue.global().async {
            if let image = try? UIImage(data: Data(contentsOf: url)) {
                DispatchQueue.main.async {
                    self.completionHandler?(image)
                    self.delegate?.imageLoader(self, didLoad: image)
                }
            } else {
                let error = NSError(domain: "ImageLoaderError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
                DispatchQueue.main.async {
                    self.completionHandler?(nil)
                    self.delegate?.imageLoader(self, didFailWith: error)
                }
            }
        }
    }
}

class PostView {
    var imageLoader: ImageLoader?
    
    func setupImageLoader() {
        imageLoader = ImageLoader()
        imageLoader?.completionHandler = { [weak self] image in
            if let img = image {
                print("Image loaded successfully")
            } else {
                print("Failed to load image")
            }
        }
    }
}







//import Foundation
//import UIKit
//
//protocol ImageLoaderDelegate: AnyObject {
//    // TODO: Think about protocol requirements
//    // Consider: What types can conform to this protocol?
//    // Также AnyObject
//    
//    // Consider: How does this affect memory management?
//    // Делегаты будут с weak связью, что не допустит утечки памяти
//    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage)
//    func imageLoader(_ loader: ImageLoader, didFailWith error: Error)
//}
//
//class ImageLoader {
//    // TODO: Consider reference type for delegate
//    weak var delegate: ImageLoaderDelegate?
//    
//    // TODO: Think about closure reference type
//    var completionHandler: ((UIImage?) -> Void)?
//    
//    private var imageCache = NSCache<NSURL, UIImage>()
//
//    func loadImage(url: URL) {
//        if let cachedImage = imageCache.object(forKey: url as NSURL) {
//            DispatchQueue.main.async {
//                self.delegate?.imageLoader(self, didLoad: cachedImage)
//                self.completionHandler?(cachedImage)
//            }
//            return
//        }
//
//        DispatchQueue.global().async { [weak self] in
//            guard let self = self else { return }
//            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                self.imageCache.setObject(image, forKey: url as NSURL)
//                DispatchQueue.main.async {
//                    self.delegate?.imageLoader(self, didLoad: image)
//                    self.completionHandler?(image)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.delegate?.imageLoader(self, didFailWith: NSError(domain: "ImageLoadError", code: 500, userInfo: nil))
//                    self.completionHandler?(nil)
//                }
//            }
//        }
//    }
//
//    
//class PostView {
//    var imageLoader: ImageLoader?
//        
//    private let postImageView = UIImageView()
//        
//    func setupImageLoader() {
//        imageLoader = ImageLoader()
//        imageLoader?.completionHandler = { [weak self] image in
//            guard let self = self, let image = image else { return }
//            DispatchQueue.main.async {
//                self.postImageView.image = image
//            }
//        }
//    }
//        
//    func loadImage(from url: URL) {
//        imageLoader?.loadImage(url: url)
//    }
//}
//}
