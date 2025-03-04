//
//  Hero.swift
//  HeroRandomizer
//
//  Created by Амина Аманжолова on 02.03.2025.
//

import Foundation

struct Hero: Codable, Identifiable, Equatable {
    static func == (lhs: Hero, rhs: Hero) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    let id: Int
    let name: String
    let powerstats: PowerStats
    let biography: Biography
    let appearance: Appearance
    let work: Work
    let images: Images
}

struct PowerStats: Codable {
    let intelligence, strength, speed, durability, power, combat: Int
}

struct Biography: Codable {
    let fullName: String?
    let placeOfBirth: String?
    let publisher: String?
}

struct Appearance: Codable {
    let gender: String
    let race: String?
    let height: [String]
    let eyeColor: String
    let hairColor: String
}

struct Work: Codable {
    let occupation: String
}

struct Images: Codable {
    let md: String
}
