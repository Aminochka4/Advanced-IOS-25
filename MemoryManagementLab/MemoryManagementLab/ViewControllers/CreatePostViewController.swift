//
//  CreatePostViewController.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class CreatePostViewController: UIViewController {
    @IBOutlet weak var postTextView: UITextView!
    private let feedSystem = FeedSystem.shared
    private var profileManager = ProfileManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let content = postTextView.text, !content.isEmpty else { return }

        guard let user = profileManager.getUserProfile() else { return }
        let newPost = Post(id: UUID(), author: user, content: content, likes: 0)

        feedSystem.addPost(newPost) 
        dismiss(animated: true, completion: nil)
    }
}

