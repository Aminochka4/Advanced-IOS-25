//
//  ImageLoader.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

protocol ImageLoaderDelegate: AnyObject {
    // TODO: Think about protocol requirements
    // Consider: What types can conform to this protocol?
    // Consider: How does this affect memory management?
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage)
    func imageLoader(_ loader: ImageLoader, didFailWith error: Error)
}

class ImageLoader {
    // TODO: Consider reference type for delegate
    weak var delegate: ImageLoaderDelegate?
    
    // TODO: Think about closure reference type
    var completionHandler: ((UIImage?) -> Void)?

    func loadImage(url: URL) {
        // TODO: Implement image loading
        // Consider: How to avoid retain cycle?
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
    // TODO: Consider reference management
    var imageLoader: ImageLoader?

    func setupImageLoader() {
        // TODO: Implement setup
        // Think: What reference types should be used?
        imageLoader = ImageLoader()
    }
}
