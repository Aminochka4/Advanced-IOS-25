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
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(username)
            hasher.combine(profileImageURL)
    }
        
    // TODO: Implement Equatable
    // Consider: Which properties determine equality?
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id &&
               lhs.username == rhs.username &&
               lhs.profileImageURL == rhs.profileImageURL
    }
}
