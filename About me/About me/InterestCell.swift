//
//  InterestCell.swift
//  About me
//
//  Created by Амина Аманжолова on 11.02.2025.
//

import UIKit

class InterestCell: UITableViewCell {
    
    @IBOutlet weak var interestImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    func configure(with interest: Interest) {
        if let image = UIImage(named: interest.image) {
            interestImageView.image = image
        }
        titleLabel.text = interest.title
        bioLabel.text = interest.bio
    }

}
