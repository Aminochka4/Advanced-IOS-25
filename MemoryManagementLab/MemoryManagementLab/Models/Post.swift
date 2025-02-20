//
//  Post.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import Foundation

struct Post {
    let id: UUID
    let author: UserProfile
    let content: String
    let likes: Int

    // TODO: Implement Hashable
    // Consider: Which properties should be used for hashing?
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
        
    // TODO: Implement Equatable
    // Consider: When should two posts be considered equal?
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
