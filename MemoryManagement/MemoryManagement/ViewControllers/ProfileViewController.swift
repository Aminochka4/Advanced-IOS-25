//
//  ProfileViewController.swift
//  MemoryManagement
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    var profileManager: ProfileManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileManager()
    }

    func setupProfileManager() {
        profileManager = ProfileManager(delegate: self)
        profileManager?.loadProfile(id: "123") { result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.usernameLabel.text = profile.username
                    self.bioLabel.text = profile.bio
                }
            case .failure(let error):
                print("Error loading profile: \(error)")
            }
        }
    }
}

extension ProfileViewController: ProfileUpdateDelegate {
    func profileDidUpdate(_ profile: UserProfile) {
        DispatchQueue.main.async {
            self.usernameLabel.text = profile.username
            self.bioLabel.text = profile.bio
        }
    }
    
    func profileLoadingError(_ error: Error) {
        print("Failed to load profile: \(error)")
    }
}
