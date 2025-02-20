//
//  UserProfileViewController.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class UserProfileController: UIViewController, ProfileUpdateDelegate {
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
            updateUI(with: userProfile)
        }
        
        private func updateUI(with profile: UserProfile) {
            usernameLabel.text = profile.username
            bioLabel.text = profile.bio
            followersLabel.text = "Followers: \(profile.followers)"
            
            if let url = URL(string: profile.profileImageURL) {
                imageLoader.delegate = self
                imageLoader.loadImage(url: url)
            }
        }

        
        func profileDidUpdate(_ profile: UserProfile) {
            updateUI(with: profile)
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

