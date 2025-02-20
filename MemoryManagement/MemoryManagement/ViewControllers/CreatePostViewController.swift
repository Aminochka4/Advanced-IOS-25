//
//  CreatePostViewController.swift
//  MemoryManagement
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class CreatePostViewController: UIViewController {
    @IBOutlet weak var postTextView: UITextView!

        override func viewDidLoad() {
            super.viewDidLoad()
            postTextView.text = "Введите текст поста..."
        }
    
    @IBAction func publishPost(_ sender: UIButton) {
        guard let text = postTextView.text, !text.isEmpty else { return }
        
        let newPost = Post(id: UUID(), authorId: currentUser.id, content: text, likes: 0)
        
        FeedSystem.shared.addPost(newPost)
        
        dismiss(animated: true) // Закрывает экран после публикации
    }
}
