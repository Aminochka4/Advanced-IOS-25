//
//  Models.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 17.02.2025.
//
import Foundation

struct UserProfile: Hashable {
    let id: UUID
    let username: String
    var bio: String
    var followers: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Post: Hashable {
    let id: UUID
    let authorId: UUID
    var content: String
    var likes: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}






//struct UserProfile: Hashable, Equatable {
//    let id: Int
//    let username: String
//    var bio: String
//    var followers: Int
//    
//    // TODO: Implement Hashable
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(username)
//    }
//    // Consider: Which properties should be used for hashing?
//    // Remember: Only use immutable properties
//    
//    // TODO: Implement Equatable
//    static func==(lhs: UserProfile, rhs: UserProfile) -> Bool {
//        return lhs.id == rhs.id && lhs.username == rhs.username
//    }
//    // Consider: Which properties determine equality?
//}
//
////var profiles: UserProfile{
////    UserProfile(id: 1, username: "mineo_mango", bio: "I am just a girl in the world", followers: 15)
//}
//
//struct Post: Hashable, Equatable{
//    let id: UUID
//    let authorId: UUID
//    var content: String
//    var likes: Int
//    
//    // TODO: Implement Hashable
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
////        hasher.combine(authorId)
//    }
//    // Consider: Which properties should be used for hashing?
//    
//    // TODO: Implement Equatable
//    static func==(lhs: Post, rhs: Post) -> Bool {
//        return lhs.id == rhs.id //&& lhs.authorId == rhs.authorId
//    }
//    // Consider: When should two posts be considered equal?
//}
