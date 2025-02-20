//
//  FeedViewController.swift
//  MemoryManagementLab
//
//  Created by Амина Аманжолова on 20.02.2025.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var feedSystem: FeedSystem = FeedSystem.shared
    private var posts: [Post] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFeed()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        loadFeed()
    }

    func loadFeed() {
        posts = feedSystem.getPosts()
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)

            let post = posts[indexPath.row]

            var content = cell.defaultContentConfiguration()
            content.text = post.content
            content.secondaryText = "\(post.author.username)\n❤️ \(post.likes)"
            content.secondaryTextProperties.color = .gray
            content.secondaryTextProperties.numberOfLines = 2

            cell.contentConfiguration = content

            return cell
        }
}

