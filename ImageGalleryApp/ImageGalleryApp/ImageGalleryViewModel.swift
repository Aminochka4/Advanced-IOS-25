//
//  ImageGalleryViewModel.swift
//  ImageGalleryApp
//
//  Created by Амина Аманжолова on 31.03.2025.
//

import Foundation

class ImageGalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    
    func fetchImages() {
        let group = DispatchGroup()
        var newImages = [ImageModel]() // Локальный массив для новых изображений
        let queue = DispatchQueue(label: "com.gallery.imageFetch", attributes: .concurrent) // Фоновая очередь

        for _ in 1...5 {
            group.enter()
            queue.async {
                let id = UUID().uuidString
                let url = "https://picsum.photos/200/300?random=\(id)"
                let image = ImageModel(id: id, url: url)
                
                // Добавляем в локальный массив в фоновом потоке
                newImages.append(image)
                
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.images.append(contentsOf: newImages)
        }
    }
}

