//
//  StartConcentrateViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/22.
//

import UIKit
import Lottie

class StartConcentrateViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vAnimate: UIView?
    @IBOutlet weak var lbTime: UILabel?
    
    // MARK: - Variables
    
    var concentrateTime: String = "50:00"
    var restTime: String = "10"
    var countConcentrateTimer = Timer()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(concentrateTime)
        print(restTime)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTime?.text = concentrateTime
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupConcentrateAnimate()
        setTimer()
    }
    
    func setupConcentrateAnimate() {
        let vStartCount = LottieAnimationView(name: "startConcentrate")
        vStartCount.contentMode = .scaleAspectFill
        vStartCount.frame = CGRect(x: 0,
                                   y: 0,
                                   width: CGFloat((vAnimate?.frame.width)!),
                                   height: CGFloat((vAnimate?.frame.height)!))
        vStartCount.center = CGPoint(x: UIScreen.main.bounds.width * 0.99,
                                     y: UIScreen.main.bounds.height * 0.45)
        vStartCount.loopMode = .loop
        vStartCount.animationSpeed = 1
        vAnimate!.addSubview(vStartCount)
        vStartCount.play()
    }
    
    func setTimer() {
        countConcentrateTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(countConcentrate), userInfo: nil, repeats: true)
    }
    
    @objc func countConcentrate() {
        var min = Int((lbTime?.text?.suffix(2))!) ?? 0
        var h = Int((lbTime?.text?.prefix(2))!) ?? 0
        var total = h * 60 + min
        
        if total == 0 {
            countConcentrateTimer.invalidate()
            lbTime?.text = "00:00"
            return
        }
        
        total -= 1
        min = total % 60
        h = Int(floor(Float(total / 60)))
        
        print("\(h) & \(min)")
        
        if h > 9 && min > 9 {
            lbTime?.text = "\(h):\(min)"
        } else if h < 9 && min <= 9 {
            lbTime?.text = "0\(h):0\(min)"
        } else if h > 9 && min <= 9 {
            lbTime?.text = "\(h):0\(min)"
        } else {
            lbTime?.text = "0\(h):\(min)"
        }
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension

// MARK: - Protocol

