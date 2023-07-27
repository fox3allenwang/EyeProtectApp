//
//  NewLoginViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import UIKit
import Lottie

class LoginViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSingUp: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lbEye: UILabel!
    @IBOutlet weak var lbProtect:UILabel!
    @IBOutlet weak var txfView: UIView!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var lbLoginOrSingUp: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: - Variables
    let manager = NetworkManager()
    var loginOrSingUp: LoginOrSingUpStatus = .login
    enum LoginOrSingUpStatus {
        case login
        case SingUp
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
        setupBackButtom()
    }
    
    func setupBackButtom() {
        btnSingUp.imageView?.contentMode = .scaleToFill
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)

        btnBack.configuration = UIButton.Configuration.filled()
        btnBack.configuration?.cornerStyle = .medium
        btnBack.configuration?.baseBackgroundColor = .clear
        btnBack.configuration?.baseForegroundColor = .buttomColor
        btnBack.configuration?.image = image
        btnBack.alpha = 0
        btnBack.isEnabled = false
    }
    
    func setupTxfView() {
        txfView.backgroundColor = .white
        txfView.layer.shadowOffset = CGSize(width: 10, height: 10)
        txfView.layer.shadowOpacity = 20
        txfView.layer.shadowRadius = 20
        txfView.alpha = 0.2
        txfView.layer.cornerRadius = 20
        txfEmail.layer.borderColor = UIColor.buttomColor?.cgColor
        txfEmail.layer.borderWidth = 1
        txfEmail.layer.cornerRadius = 20
        txfEmail.tintColor = .buttomColor
        txfPassword.layer.borderColor = UIColor.buttomColor?.cgColor
        txfPassword.layer.borderWidth = 1
        txfPassword.layer.cornerRadius = 20
        txfPassword.tintColor = .buttomColor
        txfPassword.isSecureTextEntry = true
        txfName.layer.borderColor = UIColor.buttomColor?.cgColor
        txfName.layer.borderWidth = 1
        txfName.layer.cornerRadius = 20
        txfName.tintColor = .buttomColor
        
        txfEmail.setTextFieldImage(systemImageName: "envelope",
                                     imageX: 10,
                                     imageY: 5,
                                     imageWidth: 40,
                                     imageheight: 30)
        
        txfPassword.setTextFieldImage(systemImageName: "lock.rectangle",
                                             imageX: 10,
                                             imageY: 5,
                                             imageWidth: 40,
                                             imageheight: 30)
        txfName.setTextFieldImage(systemImageName: "person.circle",
                                             imageX: 10,
                                             imageY: 2,
                                             imageWidth: 35,
                                             imageheight: 35)
        
        
        
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
    
    // MARK: - networkManager
    
    func callLoginApi() async {
        let request = LoginRequest(email: txfEmail.text!, password: txfPassword.text!)
        Task {
            do {
                let response: GeneralResponse<String> = try await manager.requestData(method: .get,
                                                                                      path: .login,
                                                                                      parameters: request)
                if response.result == 0 {
                    print("帳號密碼正確")
                    let nextVC = MainViewController()
                    navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    print("帳號密碼錯誤")
                    Alert.showAlert(title: "帳號或密碼錯誤",
                                    message: "未找到此組帳號密碼",
                                    vc: self,
                                    confirmTitle: "確認")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func callRegisterApi() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
//        let now = Date()
        
        let request = RegisterRequest(dor: now,
                                      email: txfEmail.text!,
                                      password: txfPassword.text!,
                                      name: txfName.text!)
        Task {
            do {
                let response: GeneralResponse<String> = try await manager.requestData(method: .post,
                                                                                      path: .login,
                                                                                      parameters: request)
                if response.result == 0 {
                    print("註冊成功")
                    Alert.showAlert(title: "註冊成功", message: "", vc: self, confirmTitle: "確認")
                    loginOrSingUp = .login
                    setupLoginUI()
                    
                } else {
                    print("註冊失敗")
//                    Alert.showAlert(title: "帳號或密碼錯誤",
//                                    message: "未找到此組帳號密碼",
//                                    vc: self,
//                                    confirmTitle: "確認")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func setupLoginUI() {
        UIView.transition(with: lbLoginOrSingUp,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.lbLoginOrSingUp.text = "LOGIN"
        }
        UIView.transition(with: btnLogin,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.btnLogin.alpha = 1
            self.btnLogin.isEnabled = true
        }
        UIView.transition(with: btnBack,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.btnBack.alpha = 0
            self.btnBack.isEnabled = false
        }
        UIView.transition(with: txfName,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.txfName.alpha = 0
            self.txfName.isEnabled = false
        }
        
        let transformValue = txfEmail.frame.height + 30
        UIView.animate(withDuration: 0.3) {
            self.txfEmail.transform = CGAffineTransform(translationX: 0,
                                                          y: 0)
        }
        UIView.animate(withDuration: 0.3) {
            self.txfPassword.transform = CGAffineTransform(translationX: 0,
                                                           y: 0)
        }
        
        btnSingUp.backgroundColor = UIColor.buttomColor
    }
    
    func setupSingUpUI() {
        UIView.transition(with: lbLoginOrSingUp,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.lbLoginOrSingUp.text = "SING UP"
        }
        UIView.transition(with: btnLogin,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.btnLogin.alpha = 0
            self.btnLogin.isEnabled = false
        }
        UIView.transition(with: btnBack,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.btnBack.alpha = 1
            self.btnBack.isEnabled = true
        }
        UIView.transition(with: txfName,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.txfName.alpha = 1
            self.txfName.isEnabled = true
        }
    
        btnSingUp.backgroundColor = UIColor.buttom2Color
      
        
        let transformValue = txfEmail.frame.height + 30
        UIView.animate(withDuration: 0.3) {
            self.txfEmail.transform = CGAffineTransform(translationX: 0,
                                                          y: transformValue)
        }
        UIView.animate(withDuration: 0.3) {
            self.txfPassword.transform = CGAffineTransform(translationX: 0,
                                                           y: transformValue)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func clickLogin() {
        if txfEmail.text == "" || txfPassword.text == "" {
            Alert.showAlert(title: "帳號或密碼未輸入",
                            message: "請輸入帳號及密碼",
                            vc: self,
                            confirmTitle: "確認")
        } else {
            Task {
                await callLoginApi()
            }
        }
    }
    
    @IBAction func clickSingUp() {
        if loginOrSingUp == .login {
            setupSingUpUI()
            loginOrSingUp = .SingUp
        } else {
            if txfEmail.text == "" ||
                txfPassword.text == "" ||
                txfName.text == "" {
                Alert.showAlert(title: "名稱、帳號或密碼未輸入",
                                message: "請輸入名稱、帳號及密碼",
                                vc: self,
                                confirmTitle: "確認")
            } else {
                Task {
                    await callRegisterApi()
                }
            }
        }
    }
    
    @IBAction func clickBack() {
        loginOrSingUp = .login
        setupLoginUI()
    }
    
}

// MARK: - Extension

// MARK: - Protocol
