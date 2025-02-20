//
//  FeedViewController.swift
//  MemoryManagement
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FeedSystem.shared.delegate = self
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].content
        return cell
    }
}

extension FeedViewController: FeedSystemDelegate {
    func didUpdateFeed() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdatePosts(_ newPosts: [Post]) {
        self.posts = newPosts
        tableView.reloadData()
    }
}
