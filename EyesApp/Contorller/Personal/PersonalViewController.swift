//
//  PersonalViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import ProgressHUD

class PersonalViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tvPersonal: UITableView!
    @IBOutlet weak var igvUser: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    
    // MARK: - Variables
    let tvTitleArry = ["電子信箱", "註冊日期", "成就", "通知設定", "修改密碼"]
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PersonalViewController")
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        callGetPersonInformationApi()
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
        setupIgvUser()
        setupBtnLogout()
        setupBackgroundView()
        setupTableView()
    }
    
    func setupTableView() {
        tvPersonal.register(UINib(nibName: "PersonalLabelTableViewCell",
                                  bundle: nil),
                            forCellReuseIdentifier: PersonalLabelTableViewCell.identified)
        tvPersonal.register(UINib(nibName: "PersonalTableViewCell",
                                  bundle: nil),
                            forCellReuseIdentifier: PersonalTableViewCell.identified)
        tvPersonal.dataSource = self
        tvPersonal.delegate = self
    }
    
    func setupIgvUser() {
        igvUser.layer.cornerRadius = igvUser.frame.width / 2
        igvUser.layer.borderWidth = 3
        igvUser.layer.borderColor = UIColor.buttomColor?.cgColor
    }
    
    func setupBtnLogout() {
        btnLogout.layer.cornerRadius = 20
        btnLogout.alpha = 0.8
    }
    
    func setupBackgroundView() {
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        backgroundView.layer.shadowOpacity = 0.7
        backgroundView.layer.shadowRadius = 20
        backgroundView.alpha = 0.2
    }
    
    func callUploadImageApi(imageString: String) {
        let request = UploadImageRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!, image: imageString)
        
        Task {
            do {
                let response: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                               path: .uploadImage,
                                                                                               parameters: request,
                                                                                               needToken: true)
                print(response)
                callGetPersonInformationApi()
            } catch {
                print(error)
            }
        }
        
    }
    
    func callGetPersonInformationApi() {
        let request = GetPersonInfromationRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        
        Task{
            do {
                let response: GeneralResponse<GetPersonInfromationResponse> = try await NetworkManager().requestData(method: .post,
                                                                                                                     path: .getPersonInformation,
                                                                                                                     parameters: request,
                                                                                                                     needToken: true)
                UserPreferences.shared.dor = response.data!.dor
                UserPreferences.shared.email = response.data!.email
                UserPreferences.shared.name = response.data!.name
                lbUserName.text = UserPreferences.shared.name
                guard response.data?.image == "未設置" else {
                    let imageString = response.data!.image
                    let image = imageString.stringToUIImage()
                    igvUser.image = image
                    ProgressHUD.dismiss()
                    return
                }
                ProgressHUD.dismiss()
            } catch {
                print(error)
            }
        }
    }
    
// MARK: - callLogoutAPI
    
    func callLogoutApi() {
        let request = LogoutRequest(accountId: UserPreferences.shared.accountId)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .logout,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.data == "登出成功" {
                    UserPreferences.shared.resetInitialFlowVarables()
                    let nextVC = LoginViewController()
                    navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    Alert.showAlert(title: "登出失敗", message: "帳號資訊有誤", vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "登出失敗", message: "請確認與伺服器的連線", vc: self, confirmTitle: "確認")
            }
           
        }
    }
    
    // MARK: - IBAction
    @IBAction func clickBtnLogout() {
        callLogoutApi()
    }
    
    @IBAction func uploadAndSetImage() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
        
    }
    
}

// MARK: - PersonalTableViewExtension

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalLabelTableViewCell.identified,
                                                      for: indexPath) as! PersonalLabelTableViewCell
            cell.title.text = tvTitleArry[indexPath.row]
            cell.value.text = UserPreferences.shared.email
            return cell
        case 1:
            let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalLabelTableViewCell.identified,
                                                      for: indexPath) as! PersonalLabelTableViewCell
            cell.title.text = tvTitleArry[indexPath.row]
            cell.value.text = UserPreferences.shared.dor
            return cell
        case 2:
            let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identified,
                                                      for: indexPath) as! PersonalTableViewCell
            cell.title.text = tvTitleArry[indexPath.row]
            return cell
        case 3:
            let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identified,
                                                      for: indexPath) as! PersonalTableViewCell
            cell.title.text = tvTitleArry[indexPath.row]
            return cell
        default:
            let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identified,
                                                      for: indexPath) as! PersonalTableViewCell
            cell.title.text = tvTitleArry[indexPath.row]
            return cell
        }
    }
    
    
}

// MARK: - UIImagePickerControllerExtension

extension PersonalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("取消選擇圖片")
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("選擇圖片")
        let image = info[.editedImage] as? UIImage
        igvUser.image = image
        let imageString = image?.imageToBase64()
        print("=================================")
        print("\(imageString)")
        print("=================================")
        callUploadImageApi(imageString: imageString!)
        picker.dismiss(animated: true)
    }
   
}


// MARK: - Protocol
