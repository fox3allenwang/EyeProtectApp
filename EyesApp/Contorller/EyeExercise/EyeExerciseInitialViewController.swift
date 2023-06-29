//
//  EyeExerciseInitialViewController.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/19.
//

import UIKit

class EyeExerciseInitialViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        continueButton.layer.cornerRadius = 5
        contentLabel.backgroundColor = UIColor(red: 201/255, green: 203/255, blue: 224/255, alpha: 1)
        contentLabel.layer.cornerRadius = 10
        contentLabel.layer.masksToBounds = true
        navigationItem.title = "護眼運動"
    }
    
    // MARK: - IBAction
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        let nextVC = EyeExerciseViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
