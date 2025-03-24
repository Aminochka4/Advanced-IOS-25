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
    @Published var favorites: [Hero] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedHero: Hero?

    private var cancellables = Set<AnyCancellable>()
    private let service = HeroService()

    // Возвращает список героев, отфильтрованных по searchText
    var filteredHeroes: [Hero] {
        searchText.isEmpty ? heroes : heroes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    // Запрашивает список героев, обновляет heroes и обрабатывает ошибки
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

    // Загружает детали героя и обновляет selectedHero
    func fetchHeroDetails(id: Int) {
        isLoading = true
        errorMessage = nil
        
        service.fetchHeroDetails(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] hero in
                self?.selectedHero = hero
            })
            .store(in: &cancellables)
    }

    // Добавление и удаление героя из избранного
    func toggleFavorite(hero: Hero) {
        if let index = favorites.firstIndex(of: hero) {
            favorites.remove(at: index)
        } else {
            favorites.append(hero)
        }
    }

    // Проверяю является ли герой избранным
    func isFavorite(hero: Hero) -> Bool {
        return favorites.contains(hero)
    }
}
