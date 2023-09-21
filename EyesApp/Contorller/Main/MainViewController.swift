//
//  MainViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import Lottie

class MainViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var customTabBarView: CustomTabBarView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var cameraManuView: UIView!
    @IBOutlet weak var btnFatigueDetection: UIButton!
    @IBOutlet weak var btnEyeExcrise: UIButton!
    
    
    // MARK: - Variables
    let socialVC = SocialViewController()
    let equipmentVC = EquipmentViewController()
    let concentrateVC = ConcentrateViewController()
    let NewsVC = NewsViewController()
    let personalVC = PersonalViewController()
    var vc: [UIViewController] = []
    let vcTitleArray = ["NEWS", "SOCILA", "CONCENTRATE", "EQUIPMENT", "PERSIONAL"]
    var cameraMenuButtomItem: UIBarButtonItem?
    var lastVC: Int? = nil
    
    var cameraMenuStatus: CameraMenueStatus = .close
    enum CameraMenueStatus {
        case open
        case close
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationbar(backgroundcolor: .buttom2Color)
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
        setupAnimate()
        setupCameraMenuView()
    }
    
    func setupCameraMenuView() {
        cameraManuView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cameraManuView.layer.shadowOpacity = 0.4
        cameraManuView.layer.shadowRadius = 20
        cameraManuView.alpha = 0.9
        cameraManuView.layer.cornerRadius = 20
    }
    
    func setupAnimate() {
        let animationView = LottieAnimationView(name: "OLas")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: animateView.frame.width * 10, height: animateView.frame.height * 4)
        animationView.center = CGPoint(x: animateView.bounds.size.width * 0.53, y:  animateView.bounds.size.height * 2)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animateView.addSubview(animationView)
        animationView.play()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        navigationItem.hidesBackButton = true
        
        cameraMenuButtomItem = UIBarButtonItem(image: UIImage(systemName: "vial.viewfinder"), style: .done, target: self, action: #selector(clickCameraMenu))
        
        navigationItem.rightBarButtonItems = [cameraMenuButtomItem!]
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
        vc = [NewsVC, socialVC, concentrateVC, equipmentVC, personalVC]
        if children.first(where: { String(describing: $0.classForCoder) == String(describing: vc[index].classForCoder) }) == nil {
            addChild(vc[index])
            vc[index].view.frame = containerView.bounds
        }
        navigationItem.title = vcTitleArray[index]
        // 將中間的 container 替換成閉包, delegate 帶進來的值
        containerView.addSubview(vc[index].view)
    }
    
    // MARK: - IBAction
    
    @objc func clickCameraMenu() {
        let transformValue = cameraManuView.frame.width
        if cameraMenuStatus == .open {
            UIView.animate(withDuration: 0.1) {
                self.cameraManuView.transform = CGAffineTransform(translationX: 0,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnFatigueDetection.transform = CGAffineTransform(translationX: 0,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnEyeExcrise.transform = CGAffineTransform(translationX: 0,
                                                              y: 0)
            }
            cameraMenuStatus = .close
        } else {
            UIView.animate(withDuration: 0.1) {
                self.cameraManuView.transform = CGAffineTransform(translationX: 0 - transformValue,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnFatigueDetection.transform = CGAffineTransform(translationX: 0 - transformValue,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnEyeExcrise.transform = CGAffineTransform(translationX: 0 - transformValue,
                                                              y: 0)
            }
            cameraMenuStatus = .open
        }
    }
    
    @IBAction func clickBtnEyeExercise() {
        let nextVC = EyeExerciseViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

// MARK: - Extension

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


// MARK: - Protocol
