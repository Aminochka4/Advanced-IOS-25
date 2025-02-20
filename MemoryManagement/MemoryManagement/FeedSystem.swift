//
//  FeedSystem.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 17.02.2025.
//

import Foundation

protocol FeedSystemDelegate: AnyObject {
    func didUpdateFeed()
}

class FeedSystem {
    weak var delegate: FeedSystemDelegate?
    private var userCache: [UUID: UserProfile] = [:]
    private var feedPosts: [Post] = []
    private var hashtags: Set<String> = []
    
    static let shared = FeedSystem() // Добавляем синглтон

        private init() {}
    
    func addPost(_ post: Post) {
        feedPosts.insert(post, at: 0)
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
}



//import Foundation
//
//class FeedSystem {
//    // TODO: Implement cache storage
//    // Consider: Which collection type is best for fast lookup?
//    // Requirements: O(1) access time, storing UserProfile objects with UserID keys
//    private var userCache: [UUID: UserProfile] = [:]
//    
//    // TODO: Implement feed storage
//    // Consider: Which collection type is best for ordered data?
//    // Requirements: Maintain post order, frequent insertions at the beginning
//    private var feedPosts: [Post] = []
//    
//    // TODO: Implement hashtag storage
//    // Consider: Which collection type is best for unique values?
//    // Requirements: Fast lookup, no duplicates
//    private var hashtags: Set<String> = []
//    
//    func addPost(_ post: Post) {
//        // TODO: Implement post addition
//        feedPosts.insert(post, at: 0)
//        hashtags.formUnion(post.content.split(separator: " ").map { String($0) })
//        // Consider: Which collection operations are most efficient?
//    }
//    
//    func removePost(_ post: Post) {
//        // TODO: Implement post removal
//        if let index = feedPosts.firstIndex(of: post) {
//            feedPosts.remove(at: index)
//        }
//        // Consider: Performance implications of removal
//    }
//}
