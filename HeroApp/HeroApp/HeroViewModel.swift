//
//  ViewModel.swift
//  HeroApp
//
//  Created by Амина Аманжолова on 16.03.2025.
//

import Foundation
import Combine
import SwiftUI

class HeroViewModel: ObservableObject {
    @Published var heroes: [Hero] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let service = HeroService()

    var filteredHeroes: [Hero] {
        searchText.isEmpty ? heroes : heroes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    func fetchHeroes() {
        isLoading = true
        service.fetchHeroes()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] heroes in
                self?.heroes = heroes
            })
            .store(in: &cancellables)
    }
}

