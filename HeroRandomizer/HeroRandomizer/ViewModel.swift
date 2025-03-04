//
//  ViewModel.swift
//  HeroRandomizer
//
//  Created by Амина Аманжолова on 02.03.2025.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var hero: Hero? = nil
    private var allHeroes: [Hero] = []
    @Published var favorites: [Hero] = []
    @Published var showFavorites = false
    
    
    // загружает всех героев из апишки, декодирует с JSON в Hero struct и сохраняет все в allHeroes массив
    func fetchHeroes() {
        guard let url = URL(string: "https://akabab.github.io/superhero-api/api/all.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                DispatchQueue.main.async {
                    self.allHeroes = heroes
                    //self.fetchRandomHero()
                }
            } catch {
                print("Ошибка загрузки героев: \(error)")
            }
        }.resume()
    }
    
    // рандомно выбирает одного героя из массива
    func fetchRandomHero() {
        guard !allHeroes.isEmpty else { return }
        DispatchQueue.main.async {
            self.hero = self.allHeroes.randomElement()
        }
    }
    
    // добавляет героев в Favorite list, если их там нет, и удалает, если есть
    func toggleFavorite(hero: Hero) {
        if let index = favorites.firstIndex(of: hero) {
            favorites.remove(at: index)
        } else {
            favorites.append(hero)
        }
    }

    // проверяет есть ли определенный герой в списке Favorites и возвращает bool ответ
    func isFavorite(hero: Hero) -> Bool {
        return favorites.contains(hero)
    }

    // меняет экраны между Favorite list and Randomizer, меняя значение showFavorites 
    func toggleFavoritesView() {
        showFavorites.toggle()
    }
}
