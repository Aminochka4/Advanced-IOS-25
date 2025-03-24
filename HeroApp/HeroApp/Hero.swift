//
//  Hero.swift
//  HeroApp
//
//  Created by Амина Аманжолова on 16.03.2025.
//

import SwiftUI
import Combine

struct Hero: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let powerstats: PowerStats
    let biography: Biography
    let appearance: Appearance
    let work: Work
    let images: Images
}

struct PowerStats: Codable, Hashable {
    let intelligence, strength, speed, durability, power, combat: Int
}

struct Biography: Codable, Hashable {
    let fullName: String?
    let placeOfBirth: String?
    let publisher: String?
}

struct Appearance: Codable, Hashable {
    let gender: String
    let race: String?
    let height: [String]
    let eyeColor: String
    let hairColor: String
}

struct Work: Codable, Hashable {
    let occupation: String
}

struct Images: Codable, Hashable {
    let md: String
}
