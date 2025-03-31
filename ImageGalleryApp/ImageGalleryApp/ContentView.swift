//
//  ContentView.swift
//  ImageGalleryApp
//
//  Created by Амина Аманжолова on 31.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ImageGalleryViewModel()

    let columns = [GridItem(.adaptive(minimum: 100))] // Гибкая сетка

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.images) { image in
                            AsyncImage(url: URL(string: image.url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable().scaledToFit()
                                case .failure:
                                    Image(systemName: "xmark.octagon").resizable().scaledToFit()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 150)
                        }
                    }
                    .padding()
                }

                Button("Добавить 5 изображений") {
                    viewModel.fetchImages()
                }
                .padding()
            }
            .navigationTitle("Pinterest Gallery")
        }
    }
}


#Preview {
    ContentView()
}
