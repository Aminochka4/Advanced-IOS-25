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
    @IBOutlet weak var toggleButton: UIButton!  // Подключи кнопку в сториборде!

    override func viewDidLoad() {
        super.viewDidLoad()
        goalImageView.alpha = 0  // Скрыто по умолчанию
        goalLabel.alpha = 0
    }

    @IBAction func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {  // Плавное появление
            self.goalImageView.alpha = 1
            self.goalLabel.alpha = 1
        }
    }

    @IBAction func buttonTouchUp(_ sender: UIButton) {
        self.goalImageView.alpha = 0  // Исчезает мгновенно
        self.goalLabel.alpha = 0
    }
}


