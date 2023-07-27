//
//  MainViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit

class MainViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var customTabBarView: CustomTabBarView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Variables
    let socialVC = SocialViewController()
    let equipmentVC = EquipmentViewController()
    let concentrateVC = ConcentrateViewController()
    let fatigueDetectionVC = FatigueDetectionViewController()
    let personalVC = PersonalViewController()
    var vc: [UIViewController] = []
    let vcTitleArray = ["SOCILA", "EQUIPMENT", "CONCENTRATE", "FATIGUEDETECTION", "PERSIONAL"]
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        setupNavigation()
        setupCustomTabBarView()
    }
    
    func setupNavigation() {
        setNavigationbar(backgroundcolor: .buttom2Color)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    
    func setupCustomTabBarView() {
        customTabBarView.layer.cornerRadius = 25
        customTabBarView.clipsToBounds = true
        customTabBarView.layer.borderWidth = 2
        customTabBarView.layer.borderColor = UIColor.buttomColor?.cgColor
        updateView(index: 2)
        customTabBarView.tapIndexClosure = { index in
            self.updateView(index: index)
        }
    }
    
    func updateView(index: Int) {
        // 會逐個掃描，並把 vc 裡 children 沒有的 view 放進 children 裡
        vc = [socialVC, equipmentVC, concentrateVC, fatigueDetectionVC, personalVC]
        if children.first(where: { String(describing: $0.classForCoder) == String(describing: vc[index].classForCoder) }) == nil {
            addChild(vc[index])
            vc[index].view.frame = containerView.bounds
        }
        navigationItem.title = vcTitleArray[index]
        // 將中間的 container 替換成閉包, delegate 帶進來的值
        containerView.addSubview(vc[index].view)
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension


// MARK: - Protocol
