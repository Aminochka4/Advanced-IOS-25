//
//  ImageGalleryViewModel.swift
//  ImageGalleryApp
//
//  Created by Амина Аманжолова on 31.03.2025.
//

import Foundation

class ImageGalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var errorMessage: String?
    
    func fetchImages() {
        let group = DispatchGroup()
        var newImages = [ImageModel]()
        let queue = DispatchQueue(label: "com.gallery.imageFetch", attributes: .concurrent)
        let syncQueue = DispatchQueue(label: "com.gallery.syncQueue") // Очередь для синхронизации

        for _ in 1...5 {
            group.enter()
            queue.async {
                let id = UUID().uuidString
                let urlString = "https://picsum.photos/200/300?random=\(id)"
                
                guard let url = URL(string: urlString), let _ = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error loading image"
                    }
                    group.leave()
                    return
                }

                let image = ImageModel(id: id, url: urlString)
                
                syncQueue.async {
                    newImages.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.images.append(contentsOf: newImages) // Обновление UI одним разом
        }
    }
    
    func retryLoading(image: ImageModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            let newUrl = "https://picsum.photos/200/300?random=\(UUID().uuidString.prefix(8))"
            DispatchQueue.main.async {
                if let index = self.images.firstIndex(where: { $0.id == image.id }) {
                    self.images[index] = ImageModel(id: image.id, url: newUrl)
                }
            }
        }
    }

}
