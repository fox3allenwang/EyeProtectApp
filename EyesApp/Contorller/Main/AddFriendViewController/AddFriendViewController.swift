//
//  AddFriendViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/20.
//

import UIKit
import ProgressHUD

class AddFriendViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    
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
        self.view.layer.cornerRadius = 50
        vBackground.layer.cornerRadius = 50
        setupTxf()
        setupBtn()
    }
    
    func setupTxf() {
        txfName.layer.cornerRadius = 20
        txfEmail.layer.cornerRadius = 20
        txfName.layer.borderWidth = 2
        txfName.layer.borderColor = UIColor.secondaryLabel.cgColor
        txfEmail.layer.borderColor = UIColor.secondaryLabel.cgColor
        txfEmail.layer.borderWidth = 2
        txfEmail.leftView = UIView(frame: CGRectMake(0, 0, 10, 0))
        txfEmail.leftViewMode = .always;
        txfName.leftView = UIView(frame: CGRectMake(0, 0, 10, 0))
        txfName.leftViewMode = .always;
    }
    
    func setupBtn() {
        btnAdd.layer.cornerRadius = 20
    }
    
    //MARK: - callAddFriendInviteAPI
    
    func callAddFriendInviteApi(accountId: UUID,
                                name: String,
                                email: String) {
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("寄出中...")
        let request = AddFriendInviteRequest(accountId: accountId,
                                             name: name,
                                             email: email)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                          path: .addFriendInvite,
                                                          parameters: request,
                                                          needToken: true)
                if result.data == "寄送邀請成功" {
                    ProgressHUD.dismiss()
                    Alert.showToastWith(message: "邀請已寄出", vc: self, during: .short) {
                        NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
                    }
                } else if result.data == "對方已寄邀請給你"{
                    ProgressHUD.dismiss()
                    Alert.showToastWith(message: "對方已寄邀請給你", vc: self, during: .short) {
                        NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
                    }
                } else if result.data == "你和對方已經是好友" {
                    ProgressHUD.dismiss()
                    Alert.showToastWith(message: "你和對方已經是好友", vc: self, during: .short) {
                        NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
                    }
                } else {
                    Alert.showToastWith(message: "沒有找到被邀請者帳號", vc: self, during: .short) {
                        ProgressHUD.dismiss()
                        NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
                    }
                }
            } catch {
                print(error)
                ProgressHUD.dismiss()
                Alert.showToastWith(message: "寄出失敗,請確認與伺服器的連線", vc: self, during: .short) {
                    NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
                }
            }
            btnAdd.isEnabled = false
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func clickAddFriendBtn() {
        if txfName.text == UserPreferences.shared.name && txfEmail.text == UserPreferences.shared.email {
            Alert.showToastWith(message: "請勿輸入自己的帳號", vc: self, during: .short)
        } else  if txfName.text != "" || txfEmail.text != "" {
            callAddFriendInviteApi(accountId: UUID(uuidString: UserPreferences.shared.accountId)!,
                                   name: txfName.text!,
                                   email: txfEmail.text!)
            btnAdd.isEnabled = false
        } else {
            Alert.showToastWith(message: "請輸入完整資訊", vc: self, during: .short)
        }
    }
    
}

// MARK: - Extension

// MARK: - Protocol

