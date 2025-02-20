//
//  ProfileManager.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 17.02.2025.
//

import Foundation
import UIKit

protocol ProfileUpdateDelegate: AnyObject {
    func profileDidUpdate(_ profile: UserProfile)
    func profileLoadingError(_ error: Error)
}

class ProfileManager {
    private var activeProfiles: [String: UserProfile] = [:]
    weak var delegate: ProfileUpdateDelegate?
    var onProfileUpdate: ((UserProfile) -> Void)?
    
    init(delegate: ProfileUpdateDelegate) {
        self.delegate = delegate
    }
    
    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if let profile = self.activeProfiles[id] {
                DispatchQueue.main.async {
                    completion(.success(profile))
                    self.delegate?.profileDidUpdate(profile)
                    self.onProfileUpdate?(profile)
                }
            } else {
                let error = NSError(domain: "ProfileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
                DispatchQueue.main.async {
                    completion(.failure(error))
                    self.delegate?.profileLoadingError(error)
                }
            }
        }
    }
}

class UserProfileViewController: UIViewController, ProfileUpdateDelegate {
    var profileManager: ProfileManager?
    var imageLoader: ImageLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileManager()
    }
    
    func setupProfileManager() {
        profileManager = ProfileManager(delegate: self)
        profileManager?.onProfileUpdate = { [weak self] profile in
            self?.updateProfileUI(with: profile)
        }
    }
    
    func updateProfile() {
        profileManager?.loadProfile(id: "1234") { [weak self] result in
            switch result {
            case .success(let profile):
                self?.updateProfileUI(with: profile)
            case .failure(let error):
                print("Failed to load profile: \(error.localizedDescription)")
            }
        }
    }
    
    func updateProfileUI(with profile: UserProfile) {
        print("Updating UI with profile: \(profile.username)")
    }
    
    func profileDidUpdate(_ profile: UserProfile) {
        updateProfileUI(with: profile)
    }
    
    func profileLoadingError(_ error: Error) {
        print("Error loading profile: \(error.localizedDescription)")
    }
}









//import Foundation
//import UIKit
//
//protocol ProfileUpdateDelegate: AnyObject { //
//    // TODO: Consider protocol inheritance requirements
//    // Think: When should we restrict protocol to reference types only?
//    
//    // Ограничение протоколов только ссылочными типами нужно тогда, когда делегат используется только классами, а не структарами, чтобы избежать копирования
//    // В этом же случае я добавила AnyObject к протоколу, чтобы ограничить его только для классов
//    func profileDidUpdate(_ profile: UserProfile)
//    func profileLoadingError(_ error: Error)
//}
//
//class ProfileManager {
//    // TODO: Think about appropriate storage type for active profiles
//    
//    // Dictionary позволяет находить пользователей по id за O(1)
//    private var activeProfiles: [String: UserProfile]
//    
//    // TODO: Consider reference type for delegate
//    
//    // Делегаты обьявляют weak связь, чтобы избежать retain cycle -> утечки памяти
//    weak var delegate: ProfileUpdateDelegate?
//    
//    // TODO: Think about reference management in closure
//    
//    // В closure также необходимо использовать weak self, чтобы избежать retain cycle внутри closure
//    var onProfileUpdate: ((UserProfile) -> Void)?
//    
//    init(delegate: ProfileUpdateDelegate) {
//        // TODO: Implement initialization
//        self.delegate = delegate
//        self.activeProfiles = [:]
//    }
//    
//    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
//        // TODO: Implement profile loading
//        DispatchQueue.global().async { [weak self] in //Запускает процесс в фоновом режиме асинхронно, чтобы не мешать другим процессам
//                    guard let self = self else { return }
//                    if let profile = self.activeProfiles[id] {
//                        DispatchQueue.main.async { // Здесь уже запускает процесс на главном потоке, чтобы обновить UI
//                            completion(.success(profile))
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            completion(.failure(NSError(domain: "ProfileNotFound", code: 404, userInfo: nil)))
//                        }
//                    }
//                }
//        func setProfile(_ profile: UserProfile) {
//            activeProfiles[profile.id.uuidString] = profile
//            delegate?.profileDidUpdate(profile)
//            onProfileUpdate?(profile)
//        }
//        // Consider: How to avoid retain cycle in completion handler?
//        
//        // Поставить weak связь для self и проверять существует ли self
//    }
//}
//
//class UserProfileViewController: UIViewController, ProfileUpdateDelegate {
//    func profileDidUpdate(_ profile: UserProfile) {
//        <#code#>
//    }
//    
//    var profileManager: ProfileManager?
//    var imageLoader: ImageLoader?
//
//    private let usernameLabel = UILabel()
//    private let bioLabel = UILabel()
//    private let profileImageView = UIImageView()
//    
//    var userProfile: UserProfile? {
//        didSet {
//            updateProfileUI()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupProfileManager()
//        userProfile = UserProfile(id: 1, username: "mineo_mango", bio: "I am just a girl in the world", followers: 15)
//    }
//
//    func setupProfileManager() {
//        profileManager = ProfileManager(delegate: self)
//        profileManager?.onProfileUpdate = { [weak self] profile in
//            self?.userProfile = profile
//        }
//    }
//
//    func updateProfileUI() {
//        guard let profile = userProfile else { return }
//
//        usernameLabel.text = profile.username
//        bioLabel.text = profile.bio
//        
//        if let imageLoader = imageLoader {
//            imageLoader.loadImage(url: <#URL#>, for: profile.id) { [weak self] image in
//                DispatchQueue.main.async {
//                    self?.profileImageView.image = image
//                }
//            }
//        } else {
//            profileImageView.image = UIImage(systemName: "person.circle.fill")
//        }
//    }
//
////    func profileDidUpdate(_ profile: UserProfile) {
////        updateProfileUI(with: profile)
////    }
//
//    func profileLoadingError(_ error: Error) {
//        print("Ошибка загрузки профиля: \(error.localizedDescription)")
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//        profileImageView.contentMode = .scaleAspectFit
//        usernameLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        bioLabel.numberOfLines = 0
//
//        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel, bioLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        view.addSubview(stackView)
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//    }
//}
