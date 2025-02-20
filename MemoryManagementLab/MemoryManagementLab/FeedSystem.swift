//
//  FeedSystem.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import Foundation

class FeedSystem {
    static let shared = FeedSystem()
    
    private var userCache: [UUID: UserProfile] = [:]
    private var feedPosts: [Post] = []
    private var hashtags: Set<String> = []
    
    private init() {
        let user1 = UserProfile(id: UUID(), username: "Amina", profileImageURL: "https://example.com/amina.jpg", bio: "Hello, world! I am Amina.", followers: 300)
        let user2 = UserProfile(id: UUID(), username: "JohnDoe", profileImageURL: "https://example.com/johndoe.jpg", bio: "Tech enthusiast!", followers: 150)
        let user3 = UserProfile(id: UUID(), username: "JaneDoe", profileImageURL: "https://example.com/janedoe.jpg", bio: "Love coding!", followers: 500)

        userCache[user1.id] = user1
        userCache[user2.id] = user2
        userCache[user3.id] = user3


        let post1 = Post(id: UUID(), author: user1, content: "Привет, мир!", likes: 20)
        let post2 = Post(id: UUID(), author: user2, content: "Swift – лучший язык программирования!", likes: 15)
        let post3 = Post(id: UUID(), author: user3, content: "Кто-нибудь хочет обсудить архитектуру MVVM?", likes: 30)


        feedPosts = [post1, post2, post3]
    }

    func addPost(_ post: Post) {
        feedPosts.insert(post, at: 0)
        

        if userCache[post.author.id] == nil {
            userCache[post.author.id] = post.author
        }
        

        extractHashtags(from: post.content)
    }

    func removePost(_ post: Post) {
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
