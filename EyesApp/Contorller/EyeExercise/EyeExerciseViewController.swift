//
//  EyeExerciseViewController.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/19.
//

import UIKit

class EyeExerciseViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    
    // MARK: - Property／Variables
    
    var timer:Timer?
    
    let contents = [
        "向上看",
        "向下看",
        "向左看",
        "向右看",
        "順時針旋轉",
        "逆時針旋轉"
    ]
    let arrow = [
        "arrow.up",
        "arrow.down",
        "arrow.left",
        "arrow.right",
        "arrow.clockwise",
        "arrow.counterclockwise"
    ]
    var number = 0
    var count = 10
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(handleTimerExecution),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        navigationItem.title = "護眼運動"
        contentLabel.text = contents[0]
        arrowImage.image = UIImage(systemName: arrow[0])
        eyeImage.image = UIImage(systemName: "eye")
        continueButton.layer.cornerRadius = 5
    }
    
    // MARK: - Function
    
    @objc private func handleTimerExecution() {
        count -= 1
        secondLabel.text = String(count)
        if (count == 0) {
            count = 10
            timer?.invalidate()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        if contents.count == (number + 1) {
            Alert.showAlertWith(title: "提醒",
                                message: "護眼運動已完成",
                                vc: self,
                                confirmTitle: "確認") {
                let nextVC = EyeExerciseViewController()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            number = number + 1
            contentLabel.text = contents[number]
            arrowImage.image = UIImage(systemName: arrow[number])
            count = 10
            secondLabel.text = "\(count)"
            timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(handleTimerExecution),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
}
