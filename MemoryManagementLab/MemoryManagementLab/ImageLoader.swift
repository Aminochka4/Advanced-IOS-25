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
    // Реализовать этот протокол могут только классы, потому что проток ограничин только ссылочными типами (AnyObject)
    // Это позволяет назначать делегатам weak связь, что предотвращает retain cycle
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage)
    func imageLoader(_ loader: ImageLoader, didFailWith error: Error)
}

class ImageLoader {
    // TODO: Consider reference type for delegate
    // weak чтобы избежать утечку памяти
    weak var delegate: ImageLoaderDelegate?
    
    // TODO: Think about closure reference type
    // Само замыкание остается с strong связью, но в имплементации при использовании self назнается weak связь [weak self]
    var completionHandler: ((UIImage?) -> Void)?

    func loadImage(url: URL) {
        // TODO: Implement image loading
        // Consider: How to avoid retain cycle?
        // Используется weak self, чтобы не удерживать self в памяти. Также self проверяется, и если он пустой, то код не выполняется
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "ImageLoader", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                }
                DispatchQueue.main.async {
                    self.delegate?.imageLoader(self, didLoad: image)
                    self.completionHandler?(image)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.imageLoader(self, didFailWith: error)
                    self.completionHandler?(nil)
                }
            }
        }
    }
}

class PostView {
    // TODO: Consider reference management
    // imageLoader с strong связью, потому что он нужен в этом классе и не должен удаляться
    var imageLoader: ImageLoader?
    private var postImageView: UIImageView = UIImageView()

    func setupImageLoader() {
        // TODO: Implement setup
        // Think: What reference types should be used?
        // imageLoader создается внутри этого метода, self передается в делегат, но так как PostView это просто объект, то утечек в памяти не будет
        imageLoader = ImageLoader()
        imageLoader?.delegate = self
    }

    func loadImage(from url: URL) {
        setupImageLoader()
        imageLoader?.loadImage(url: url)
    }
}

// Реализует протокол и отвечает за обновление изображения после загрузки нового
extension PostView: ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        DispatchQueue.main.async {
            self.postImageView.image = image
        }
    }

    func imageLoader(_ loader: ImageLoader, didFailWith error: Error) {
        DispatchQueue.main.async {
            self.postImageView.image = UIImage(systemName: "exclamationmark.triangle")
        }
        print("Ошибка загрузки изображения в PostView:", error.localizedDescription)
    }
}
