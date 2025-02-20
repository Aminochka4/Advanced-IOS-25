//
//  ImageLoader.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
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
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.delegate?.imageLoader(self!, didLoad: image)
                        self?.completionHandler?(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "ImageLoader", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                        self?.delegate?.imageLoader(self!, didFailWith: error)
                        self?.completionHandler?(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.delegate?.imageLoader(self!, didFailWith: error)
                    self?.completionHandler?(nil)
                }
            }
        }
    }
}

class PostView {
    var imageLoader: ImageLoader?

    func setupImageLoader() {
        imageLoader = ImageLoader()
    }
}
