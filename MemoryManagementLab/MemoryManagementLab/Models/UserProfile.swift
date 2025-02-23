//
//  UserProfile.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import Foundation

struct UserProfile {
    let id: UUID
    let username: String
    let profileImageURL: String
    var bio: String
    var followers: Int
    
    // TODO: Implement Hashable
    // Consider: Which properties should be used for hashing?
    // Remember: Only use immutable properties
    // Хэширование по id достаточно, так как UUID уже обеспечивает уникальность, также она неизменяема в отличии от bio and followers - их для хеширование использовать нельзя
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
        
    // TODO: Implement Equatable
    // Consider: Which properties determine equality?
    // Тут тоже достаточно сравнить по id, так как она у всех уникальная(UUID)
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}
