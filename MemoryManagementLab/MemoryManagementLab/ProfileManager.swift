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
    // Нужно ограничивать протокол ссылочными типами, когда нужно чтобы протокол реализовывали только классы. Это необходимо, чтобы хранить делегат как weak, потому что weak можно использовать только для ссылочных типов.
    func profileDidUpdate(_ profile: UserProfile)
    func profileLoadingError(_ error: Error)
}

class ProfileManager {
    static let shared = ProfileManager()

    // TODO: Think about appropriate storage type for active profiles
    // Для хранения активных пользователей нужен Dictionary, потому что это позволяет получить доступ по ID за О(1).
    private var activeProfiles: [UUID: UserProfile] = [:]
    
    // TODO: Consider reference type for delegate
    // Делегат должен быть weak, чтобы избежать утечки памяти. Так как это является ссылкой на другой объект, то при strong связи и объекта и делегата, они будут удерживать друг друга создавая retain cycle.
    weak var delegate: ProfileUpdateDelegate?
    
    // TODO: Think about reference management in closure
    // Во время использования замыкания self также должен быть weak, так как это может привести к retain cycle (иначе self не освобождается пока замыкание живо).
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
        // Completion передается как @escaping, чтобы замыкание могло выполняться асинхронно и сохраняться в памяти после выхода метода. Сompletion handler используется без self. Но если бы он использовался внутри асинхронного блока, то нужно использовать weak self, чтобы избежать утечки памяти. 
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

