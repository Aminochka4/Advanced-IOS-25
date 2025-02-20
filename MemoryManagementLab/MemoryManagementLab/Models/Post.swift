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
}
