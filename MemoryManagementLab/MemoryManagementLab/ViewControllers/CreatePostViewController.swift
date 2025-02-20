//
//  CreatePostViewController.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class CreatePostViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var postTextView: UITextView!
    private let feedSystem = FeedSystem.shared
    private var profileManager = ProfileManager.shared
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let content = postTextView.text, !content.isEmpty else { return }
            
            guard let author = profileManager.getUserProfile() else {
                return
            }
            
            let newPost = Post(id: UUID(), author: author, content: content, likes: 0)
            
            feedSystem.addPost(newPost)
            
            if let feedVC = navigationController?.viewControllers.first(where: { $0 is FeedViewController }) as? FeedViewController {
                feedVC.loadFeed()
            }
            navigationController?.popViewController(animated: true)
     }
}

