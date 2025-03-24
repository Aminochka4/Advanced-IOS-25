//
//  HeroService.swift
//  HeroApp
//
//  Created by Амина Аманжолова on 16.03.2025.
//

import Foundation
import Combine

class HeroService {
    // Отправляет сетевой запрос для получения списка всех героев
    func fetchHeroes() -> AnyPublisher<[Hero], Error> {
        let url = URL(string: "https://akabab.github.io/superhero-api/api/all.json")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Hero].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Загружает информацию о конкретном герое по его ID
    func fetchHeroDetails(id: Int) -> AnyPublisher<Hero, Error> {
        let url = URL(string: "https://akabab.github.io/superhero-api/api/id/\(id).json")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Hero.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
