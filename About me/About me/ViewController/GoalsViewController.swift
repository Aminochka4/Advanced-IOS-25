//
//  GoalsViewController.swift
//  About me
//
//  Created by Амина Аманжолова on 11.02.2025.
//

import UIKit

class GoalsViewController: UIViewController {

    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        goalImageView.alpha = 0
        goalLabel.alpha = 0
    }

    @IBAction func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.goalImageView.alpha = 1
            self.goalLabel.alpha = 1
        }
    }

    @IBAction func buttonTouchUp(_ sender: UIButton) {
        self.goalImageView.alpha = 0  
        self.goalLabel.alpha = 0
    }
}


