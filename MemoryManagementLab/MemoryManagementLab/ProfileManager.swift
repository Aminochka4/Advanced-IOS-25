//
//  ProfileManager.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import Foundation

protocol ProfileUpdateDelegate: AnyObject {
    func profileDidUpdate(_ profile: UserProfile)
    func profileLoadingError(_ error: Error)
}

class ProfileManager {
    static let shared = ProfileManager()

    private var activeProfiles: [UUID: UserProfile] = [:]
    weak var delegate: ProfileUpdateDelegate?
    var onProfileUpdate: ((UserProfile) -> Void)?

    private init() {
        let currentUser = UserProfile(
            id: UUID(),
            username: "Amina",
            profileImageURL: "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
            bio: "Hello, world! I am Amina.",
            followers: 300
        )
        activeProfiles[currentUser.id] = currentUser
    }

    func loadProfile(id: UUID, completion: @escaping (Result<UserProfile, Error>) -> Void) {
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

