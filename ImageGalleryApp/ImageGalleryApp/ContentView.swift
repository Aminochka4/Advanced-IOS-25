//
//  ContentView.swift
//  ImageGalleryApp
//
//  Created by Амина Аманжолова on 31.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ImageGalleryViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.images) { image in
                            AsyncImage(url: URL(string: image.url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: CGFloat.random(in: 200...300))
                                        .cornerRadius(15)
                                        .clipped()
                                        .gridCellAnchor(.top)
                                case .failure:
                                    Button(action: { viewModel.retryLoading(image: image) }) {
                                            Image(systemName: "arrow.clockwise.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.red)
                                        }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    viewModel.fetchImages()
                }) {
                    Label("Get Images", systemImage: "photo.on.rectangle.angled")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .bold()
                        .clipShape(Capsule())
                        .padding(.horizontal, 15)
                }
            }
            .navigationTitle("Pinterest Gallery")
        }
    }
}

#Preview {
    ContentView()
}
