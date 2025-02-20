//
//  ProfileManager.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import Foundation

protocol ProfileUpdateDelegate: AnyObject {
    // TODO: Consider protocol inheritance requirements
    // Think: When should we restrict protocol to reference types only?
    func profileDidUpdate(_ profile: UserProfile)
    func profileLoadingError(_ error: Error)
}

class ProfileManager {
    static let shared = ProfileManager()

    // TODO: Think about appropriate storage type for active profiles
    private var activeProfiles: [UUID: UserProfile] = [:]
    
    // TODO: Consider reference type for delegate
    weak var delegate: ProfileUpdateDelegate?
    
    // TODO: Think about reference management in closure
    var onProfileUpdate: ((UserProfile) -> Void)?

    private init() {
        let currentUser = UserProfile(
            id: UUID(),
            username: "Amina",
            profileImageURL: "https://media.licdn.com/dms/image/v2/D4D03AQEA95YSCwXhQA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1729933185481?e=1745452800&v=beta&t=txcc5LD1NAyq53dldivxPt0m3EIfrCB4hbNcj5KHPJo",
            bio: "I am just a girl in the world",
            followers: 300
        )
        activeProfiles[currentUser.id] = currentUser
    }

    func loadProfile(id: UUID, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // TODO: Implement profile loading
        // Consider: How to avoid retain cycle in completion handler?
        if let profile = activeProfiles[id] {
            completion(.success(profile))
        } else {
            let error = NSError(domain: "ProfileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
            completion(.failure(error))
            delegate?.profileLoadingError(error)
        }
    }
    
    func getUserProfile() -> UserProfile? {
        return activeProfiles.first?.value
    }

    func addProfile(_ profile: UserProfile) {
        activeProfiles[profile.id] = profile
    }

    func updateProfile(_ profile: UserProfile) {
        activeProfiles[profile.id] = profile
        delegate?.profileDidUpdate(profile)
        onProfileUpdate?(profile)
    }
}

