//
//  UserProfileViewController.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class UserProfileController: UIViewController, ProfileUpdateDelegate {
    // TODO: Consider reference type for these properties
    var profileManager: ProfileManager = ProfileManager.shared
    var imageLoader: ImageLoader = ImageLoader()
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            profileManager.delegate = self
            loadProfile()
        }
        
    private func loadProfile() {
        guard let userProfile = profileManager.getUserProfile() else {
            print("Ошибка: профиль не найден")
            return
        }
        updateProfile(with: userProfile)
    }
    
    func setupProfileManager() {
        // TODO: Implement setup
        // Think: What reference type should be used in closure?
        profileManager.onProfileUpdate = { [weak self] updatedProfile in
            guard let self = self else { return }
            self.updateProfile(with: updatedProfile)
        }
    }
        
    func updateProfile(with profile: UserProfile) {
        // TODO: Implement profile update
        // Consider: How to handle closure capture list?
        usernameLabel.text = profile.username
        bioLabel.text = profile.bio
        followersLabel.text = "Followers: \(profile.followers)"
        
        if let url = URL(string: profile.profileImageURL) {
            imageLoader.delegate = self
            imageLoader.loadImage(url: url)
        }
    }

    func profileDidUpdate(_ profile: UserProfile) {
        updateProfile(with: profile)
    }
        
    func profileLoadingError(_ error: Error) {
        print("Ошибка загрузки профиля:", error.localizedDescription)
    }
}

extension UserProfileController: ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        DispatchQueue.main.async {
            self.profileImageView.image = image
        }
    }

    func imageLoader(_ loader: ImageLoader, didFailWith error: Error) {
        print("Ошибка загрузки изображения:", error.localizedDescription)
    }
}

