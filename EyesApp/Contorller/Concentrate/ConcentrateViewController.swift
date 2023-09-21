//
//  ConcentrateViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import FlexibleSteppedProgressBar

class ConcentrateViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var concentrateView: UIImageView?
    @IBOutlet weak var concentrateShadowView: UIView?
    @IBOutlet weak var missionBackgroundView: UIView?
    @IBOutlet weak var lbEveryDayMission: UILabel?
    @IBOutlet weak var missionTableView: UITableView?
    
    // MARK: - Variables
    var progressBar: FlexibleSteppedProgressBar!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ConcentrateViewController")
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
        setupConcentrateView()
        setupProgress()
        setupTableView()
    }
    
    func setupProgress() {
        progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        missionBackgroundView?.addSubview(progressBar)
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: missionBackgroundView!.centerXAnchor)
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: lbEveryDayMission!.bottomAnchor,
            constant: 0
        )
        let widthConstraint = progressBar.widthAnchor.constraint(equalTo: missionBackgroundView!.widthAnchor, multiplier: 0.8)
        let heightConstraint = progressBar.heightAnchor.constraint(equalTo: missionBackgroundView!.heightAnchor, multiplier: 0.05)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 5
        progressBar.lineHeight = 9
        progressBar.radius = 15
        progressBar.progressRadius = 25
        progressBar.progressLineHeight = 3
        progressBar.selectedBackgoundColor = .buttom2Color!
        progressBar.currentSelectedCenterColor = .clear
        progressBar.selectedOuterCircleStrokeColor = .buttom2Color!
        progressBar.delegate = self
       
    }
    
    func setupConcentrateView() {
        concentrateView?.layer.cornerRadius = 10
        concentrateShadowView?.layer.shadowOffset = CGSize(width: 10, height: 10)
        concentrateShadowView?.layer.shadowOpacity = 0.9
        concentrateShadowView?.layer.shadowRadius = 20
        concentrateShadowView?.layer.shadowColor = UIColor.systemGreen.cgColor
        missionBackgroundView?.layer.cornerRadius = 10
        missionBackgroundView?.layer.shadowOffset = CGSize(width: 10, height: 10)
        missionBackgroundView?.layer.shadowOpacity = 0.2
        missionBackgroundView?.layer.shadowRadius = 20
        
    }
    
    func setupTableView() {
       
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension

extension ConcentrateViewController: FlexibleSteppedProgressBarDelegate {
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return false
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int,
                     position: FlexibleSteppedProgressBarTextLocation) -> String {
        
        return ""
    }
    
    
}

// MARK: - Protocol
