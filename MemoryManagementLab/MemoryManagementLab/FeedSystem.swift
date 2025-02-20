//
//  FeedSystem.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import Foundation

class FeedSystem {
    static let shared = FeedSystem()
    
    // TODO: Implement cache storage
    // Consider: Which collection type is best for fast lookup?
    // Requirements: O(1) access time, storing UserProfile objects with UserID keys
    private var userCache: [UUID: UserProfile] = [:]
    
    // TODO: Implement feed storage
    // Consider: Which collection type is best for ordered data?
    // Requirements: Maintain post order, frequent insertions at the beginning
    private var feedPosts: [Post] = []
    
    // TODO: Implement hashtag storage
    // Consider: Which collection type is best for unique values?
    // Requirements: Fast lookup, no duplicates
    private var hashtags: Set<String> = []
    
    private init() {
        let user1 = UserProfile(id: UUID(), username: "Amina", profileImageURL: "https://media.licdn.com/dms/image/v2/D4D03AQEA95YSCwXhQA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1729933185481?e=1745452800&v=beta&t=txcc5LD1NAyq53dldivxPt0m3EIfrCB4hbNcj5KHPJo", bio: "I am just a girl in the world", followers: 300)
        let user2 = UserProfile(id: UUID(), username: "Eldar", profileImageURL: "test", bio: "test", followers: 150)
        let user3 = UserProfile(id: UUID(), username: "Ainura", profileImageURL: "test", bio: "test", followers: 500)

        userCache[user1.id] = user1
        userCache[user2.id] = user2
        userCache[user3.id] = user3


        let post1 = Post(id: UUID(), author: user1, content: "Ура я сделала интерфейс", likes: 20)
        let post2 = Post(id: UUID(), author: user2, content: "Я душнила", likes: 15)
        let post3 = Post(id: UUID(), author: user3, content: "Я лучшая мама", likes: 30)


        feedPosts = [post1, post2, post3]
    }

    func addPost(_ post: Post) {
        // TODO: Implement post addition
        // Consider: Which collection operations are most efficient?
        print("Добавляем пост: \(post.content)")
        feedPosts.insert(post, at: 0)
        
        if userCache[post.author.id] == nil {
            userCache[post.author.id] = post.author
        }

        extractHashtags(from: post.content)
    }


    func removePost(_ post: Post) {
        // TODO: Implement post removal
        // Consider: Performance implications of removal
        if let index = feedPosts.firstIndex(where: { $0.id == post.id }) {
            feedPosts.remove(at: index)
        }
    }

    private func extractHashtags(from content: String) {
        let words = content.split(separator: " ")
        for word in words where word.hasPrefix("#") {
            hashtags.insert(String(word))
        }
    }

    func getPosts() -> [Post] {
        return feedPosts
    }
}
