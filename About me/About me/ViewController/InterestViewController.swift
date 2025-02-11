//
//  InterestViewController.swift
//  About me
//
//  Created by Амина Аманжолова on 11.02.2025.
//

import UIKit

struct Interest {
    let image: String
    let title: String
    let bio: String
}

class InterestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let interests: [Interest] = [
        Interest(image: "drawing", title: "Drawing", bio: "I like to draw my favorite characters from manhwa, and I like to draw in general. It's relaxing."),
        Interest(image: "eating", title: "Yum food", bio: "I think that have a delicious meal is the best way to relax and can be the best interest."),
        Interest(image: "mountains", title: "Mountains", bio: "I like to go to the mountains occasionally and have a picnic there"),
        Interest(image: "movie", title: "watch TV series", bio: "It's clear here"),
        Interest(image: "friends", title: "Have fun", bio: "I like to have a good time with friends")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestCell", for: indexPath) as! InterestCell
        let interest = interests[indexPath.row]
        cell.configure(with: interest)
        return cell
    }
}
