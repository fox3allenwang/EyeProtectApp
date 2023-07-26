//
//  NewLoginViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSingUp: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lbEye: UILabel!
    @IBOutlet weak var lbProtect:UILabel!
    @IBOutlet weak var txfView: UIView!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfAccount: UITextField!
    
    // MARK: - Variables
    
    
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
        setupAnimate()
        setupButton()
        setupTxfView()
    }
    
    func setupTxfView() {
        txfView.backgroundColor = .white
        txfView.layer.shadowOffset = CGSize(width: 10, height: 10)
        txfView.layer.shadowOpacity = 20
        txfView.layer.shadowRadius = 20
        txfView.alpha = 0.2
        txfView.layer.cornerRadius = 20
        txfAccount.layer.borderColor = UIColor.buttomColor?.cgColor
        txfAccount.layer.borderWidth = 1
        txfAccount.layer.cornerRadius = 20
        txfAccount.tintColor = .buttomColor
        txfPassword.layer.borderColor = UIColor.buttomColor?.cgColor
        txfPassword.layer.borderWidth = 1
        txfPassword.layer.cornerRadius = 20
        txfPassword.tintColor = .buttomColor
        
        txfAccount.setTextFieldImage(systemImageName: "person.text.rectangle",
                                     imageX: 10,
                                     imageY: 5,
                                     imageWidth: 40,
                                     imageheight: 30)
        
        txfPassword.setTextFieldImage(systemImageName: "lock.rectangle",
                                             imageX: 10,
                                             imageY: 5,
                                             imageWidth: 40,
                                             imageheight: 30)
        
        
        
    }
    
    func setupButton() {
        btnLogin.layer.cornerRadius = 10
        btnSingUp.layer.cornerRadius = 10
    }
    
    func setupAnimate() {
        let animationView = LottieAnimationView(name: "EyeProtect")
        animationView.contentMode = .bottom
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.8)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.2
        backgroundView.addSubview(animationView)
        animationView.play()
    }
    
    // MARK: - IBAction
    
    @IBAction func clickLogin() {
        
    }
    
    @IBAction func clickSingUp() {
        
//        UIButton.transition(with: btnLogin, duration: 0.4,options: .transitionCrossDissolve) {
//            self.btnLogin.alpha = 0
//            self.btnLogin.isHidden = true
//        }
    }
    
}

// MARK: - Extension

// MARK: - Protocol
