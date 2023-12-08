//
//  NewLoginViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import Lottie
import ProgressHUD
import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lbEye: UILabel!
    @IBOutlet weak var lbProtect:UILabel!
    @IBOutlet weak var txfView: UIView!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var lbLoginOrSignUp: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: - Properties
    
    var loginOrSignUp: LoginOrSignUpStatus = .login
    
    enum LoginOrSignUpStatus {
        case login
        case signUp
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserPreferences.shared.accountId.isEmpty || !UserPreferences.shared.accountId.isEmpty {
            txfEmail.text = UserPreferences.shared.email
            txfPassword.text = UserPreferences.shared.password
            Task {
                await callApiLogin(email: UserPreferences.shared.email,
                                   password: UserPreferences.shared.password)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationbar(backgroundcolor: .buttom2Color)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
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
    
    fileprivate func setupUI() {
        setupAnimate()
        setupButton()
        setupTxfView()
        setupBackButtom()
    }
    
    fileprivate func setupBackButtom() {
        btnSignUp.imageView?.contentMode = .scaleToFill
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
    
    fileprivate func setupTxfView() {
        txfView.backgroundColor = .white
        txfView.layer.shadowOffset = CGSize(width: 10, height: 10)
        txfView.layer.shadowOpacity = 20
        txfView.layer.shadowRadius = 20
        txfView.alpha = 0.2
        txfView.layer.cornerRadius = 20
        txfEmail.layer.borderColor = UIColor.buttomColor.cgColor
        txfEmail.layer.borderWidth = 1
        txfEmail.layer.cornerRadius = 20
        txfEmail.tintColor = .buttomColor
        txfPassword.layer.borderColor = UIColor.buttomColor.cgColor
        txfPassword.layer.borderWidth = 1
        txfPassword.layer.cornerRadius = 20
        txfPassword.tintColor = .buttomColor
        txfPassword.isSecureTextEntry = true
        txfName.layer.borderColor = UIColor.buttomColor.cgColor
        txfName.layer.borderWidth = 1
        txfName.layer.cornerRadius = 20
        txfName.tintColor = .buttomColor
        
        txfEmail.setTextFieldImage(systemImageName: .envelope,
                                   imageX: 10,
                                   imageY: 5,
                                   imageWidth: 40,
                                   imageHeight: 30)
        
        txfPassword.setTextFieldImage(systemImageName: .lockRectangle,
                                      imageX: 10,
                                      imageY: 5,
                                      imageWidth: 40,
                                      imageHeight: 30)
        txfName.setTextFieldImage(systemImageName: .personCircle,
                                  imageX: 10,
                                  imageY: 2,
                                  imageWidth: 35,
                                  imageHeight: 35)
    }
    
    fileprivate func setupButton() {
        btnLogin.layer.cornerRadius = 10
        btnSignUp.layer.cornerRadius = 10
    }
    
    fileprivate func setupAnimate() {
        let animationView = LottieAnimationView(name: "EyeProtect")
        animationView.contentMode = .bottom
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5,
                                       y:  UIScreen.main.bounds.size.height * 0.8)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.2
        backgroundView.addSubview(animationView)
        animationView.play()
    }
    
    func setupLoginUI() {
        UIView.transition(with: lbLoginOrSignUp,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.lbLoginOrSignUp.text = "LOGIN"
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
        
        btnSignUp.backgroundColor = UIColor.buttomColor
    }
    
    func setupSignUpUI() {
        UIView.transition(with: lbLoginOrSignUp,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.lbLoginOrSignUp.text = "SIGN UP"
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
        
        btnSignUp.backgroundColor = UIColor.buttom2Color
        
        let transformValue = txfEmail.frame.height + 30
        UIView.animate(withDuration: 0.3) {
            self.txfEmail.transform = CGAffineTransform(translationX: 0, y: transformValue)
        }
        UIView.animate(withDuration: 0.3) {
            self.txfPassword.transform = CGAffineTransform(translationX: 0, y: transformValue)
        }
    }
    
    // MARK: - Call Backend RESTful API
    
    func callApiLogin(email: String, password: String) async {
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("登入中...")
        UserPreferences.shared.userDeviceToken = UserPreferences.shared.deviceToken
        print(UserPreferences.shared.userDeviceToken)
        let request = LoginRequest(email: email,
                                   password: password,
                                   deviceToken: UserPreferences.shared.userDeviceToken)
        do {
            let response: AuthenticationResponse<LoginResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                              path: .login,
                                                                                                              parameters: request,
                                                                                                              needToken: false)
            if response.result.isEqual(to: 0) {
                print("帳號密碼正確")
                UserPreferences.shared.accountId = response.data.accountId
                UserPreferences.shared.email = txfEmail.text!
                UserPreferences.shared.password = txfPassword.text!
                UserPreferences.shared.dor = response.data.dor
                UserPreferences.shared.friendList = response.data.friendList
                UserPreferences.shared.jwtToken = response.token
                ProgressHUD.showSucceed()
                
                let nextVC = MainViewController()
                navigationController?.pushViewController(nextVC, animated: true)
            } else {
                ProgressHUD.dismiss()
                print("帳號密碼錯誤")
                Alert.showAlert(title: "帳號或密碼錯誤",
                                message: "未找到此組帳號密碼",
                                vc: self,
                                confirmTitle: "確認")
            }
        } catch {
            let errorString = "\(error)"
            if errorString.contains("invalidResponse") {
                Alert.showAlert(title: "登入失敗",
                                message: "請確認帳號密碼是否正確",
                                vc: self,
                                confirmTitle: "確認")
                ProgressHUD.dismiss()
            } else {
                print(error)
                Alert.showAlert(title: "登入失敗",
                                message: "請確認與伺服器的連線",
                                vc: self,
                                confirmTitle: "確認")
                ProgressHUD.dismiss()
            }
        }
    }
    
    func callApiRegister() async {
        guard let email = txfEmail.text,
              let password = txfPassword.text,
              let name = txfName.text else {
            return
        }
        
        let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd")
        let request = RegisterRequest(dor: now,
                                      email: email,
                                      password: password,
                                      name: name,
                                      image: "未設置")
        do {
            let response: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                path: .register,
                                                                                                parameters: request,
                                                                                                needToken: false)
            if response.result.isEqual(to: 0) {
                print("註冊成功")
                Alert.showAlert(title: "註冊成功",
                                message: "",
                                vc: self,
                                confirmTitle: "確認")
                loginOrSignUp = .login
                setupLoginUI()
            } else {
                print("註冊失敗")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func clickLogin() {
        guard let email = txfEmail.text,
              let password = txfPassword.text else {
            return
        }
        if email.isEmpty || password.isEmpty {
            Alert.showAlert(title: "帳號或密碼未輸入",
                            message: "請輸入帳號及密碼",
                            vc: self,
                            confirmTitle: "確認")
        } else {
            Task {
                await callApiLogin(email: email, password: password)
            }
        }
    }
    
    @IBAction func clickSingUp() {
        if loginOrSignUp == .login {
            setupSignUpUI()
            loginOrSignUp = .signUp
        } else {
            guard let email = txfEmail.text,
                  let password = txfPassword.text,
                  let name = txfName.text else {
                return
            }
            if email.isEmpty || password.isEmpty || name.isEmpty {
                Alert.showAlert(title: "名稱、帳號或密碼未輸入",
                                message: "請輸入名稱、帳號及密碼",
                                vc: self,
                                confirmTitle: "確認")
            } else {
                Task {
                    await callApiRegister()
                }
            }
        }
    }
    
    @IBAction func clickBack() {
        loginOrSignUp = .login
        setupLoginUI()
    }
}

// MARK: - Extensions



// MARK: - Protocol
