//
//  PersonalViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import ProgressHUD
import UIKit

class PersonalViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tvPersonal: UITableView!
    @IBOutlet weak var igvUser: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tbvConcentrateRecord: UITableView!
    
    // MARK: - Properties
    
    let tvTitleAry = ["電子信箱", "註冊日期", "我的貼文", "成就", "通知設定", "修改密碼"]
    var concentrateRecordList: [FindSelfConcentrateRecordResponse.SelfConcentrateRecordItem] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PersonalViewController")
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        Task {
            await callApiGetPersonInformation()
            await callApiFindSelfConcentrateRecord(accountId: UserPreferences.shared.accountId)
            await MainActor.run {
                ProgressHUD.dismiss()
            }
        }
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
        setupIgvUser()
        setupBtnLogout()
        setupBackgroundView()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tvPersonal.register(PersonalLabelTableViewCell.loadFromNib(),
                            forCellReuseIdentifier: PersonalLabelTableViewCell.identifier)
        tvPersonal.register(PersonalTableViewCell.loadFromNib(),
                            forCellReuseIdentifier: PersonalTableViewCell.identifier)
        tvPersonal.dataSource = self
        tvPersonal.delegate = self
        tvPersonal.tag = 0
        
        tbvConcentrateRecord.register(ConcentrateRecordTableViewCell.loadFromNib(),
                                      forCellReuseIdentifier: ConcentrateRecordTableViewCell.identifier)
        tbvConcentrateRecord.register(FirstConcentrateRecordTableViewCell.loadFromNib(),
                                      forCellReuseIdentifier: FirstConcentrateRecordTableViewCell.identifier)
        tbvConcentrateRecord.delegate = self
        tbvConcentrateRecord.dataSource = self
        tbvConcentrateRecord.tag = 1
    }
    
    fileprivate func setupIgvUser() {
        igvUser.layer.cornerRadius = igvUser.frame.width / 2
        igvUser.layer.borderWidth = 3
        igvUser.layer.borderColor = UIColor.buttomColor.cgColor
    }
    
    fileprivate func setupBtnLogout() {
        btnLogout.layer.cornerRadius = 20
        btnLogout.alpha = 0.8
    }
    
    fileprivate func setupBackgroundView() {
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        backgroundView.layer.shadowOpacity = 0.7
        backgroundView.layer.shadowRadius = 20
        backgroundView.alpha = 0.2
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: UploadImageAPI
    
    func callApiUploadImage(imageString: String) async {
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        let request = UploadImageRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!,
                                         image: imageString)
        do {
            let response: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                path: .uploadImage,
                                                                                                parameters: request,
                                                                                                needToken: true)
            print(response)
            await callApiGetPersonInformation()
            ProgressHUD.dismiss()
        } catch {
            print(error)
        }
    }
    
    // MARK: GetPersonInformation
    
    func callApiGetPersonInformation() async {
        let request = GetPersonInformationRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        do {
            let response: GeneralResponse<GetPersonInformationResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                      path: .getPersonInformation,
                                                                                                                      parameters: request,
                                                                                                                      needToken: true)
            UserPreferences.shared.dor = response.data.dor
            UserPreferences.shared.email = response.data.email
            UserPreferences.shared.name = response.data.name
            lbUserName.text = UserPreferences.shared.name
            guard response.data.image.isEqual(to: "未設置") else {
                let imageString = response.data.image
                let image = imageString.stringToUIImage()
                igvUser.image = image
                return
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: Logout
    
    func callApiLogout() async {
        let request = LogoutRequest(accountId: UserPreferences.shared.accountId)
        do {
            let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                              path: .logout,
                                                                                              parameters: request,
                                                                                              needToken: true)
            if result.data.isEqual(to: "登出成功") {
                UserPreferences.shared.resetInitialFlowVarables()
                let nextVC = LoginViewController()
                navigationController?.pushViewController(nextVC, animated: true)
            } else {
                Alert.showAlert(title: "登出失敗",
                                message: "帳號資訊有誤",
                                vc: self,
                                confirmTitle: "確認")
            }
        } catch {
            print(error)
            Alert.showAlert(title: "登出失敗",
                            message: "請確認與伺服器的連線",
                            vc: self,
                            confirmTitle: "確認")
        }
    }
    
    // MARK: FindSelfConcentrateRecord
    
    func callApiFindSelfConcentrateRecord(accountId: String) async {
        let request = FindSelfConcentrateRecordRequest(accountId: UUID(uuidString: accountId)!)
        do {
            let result: GeneralResponse<FindSelfConcentrateRecordResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                         path: .findSelfConcentrateRecord,
                                                                                                                         parameters: request,
                                                                                                                         needToken: true)
            if result.message.isEqual(to: "ConcentrateRecord 是空的") ||
                result.message.isEqual(to: "找到 ConcentrateRecord 了") {
                concentrateRecordList = result.data.concentrateRecordList
                concentrateRecordList.sort { firstItem, secondItem in
                    if firstItem.startTime < secondItem.startTime {
                        return false
                    } else {
                        return true
                    }
                }
                tbvConcentrateRecord.reloadData()
            } else {
                Alert.showAlert(title: "錯誤",
                                message: result.message,
                                vc: self,
                                confirmTitle: "確認")
            }
        } catch {
            print(error)
            Alert.showAlert(title: "錯誤",
                            message: "\(error)",
                            vc: self,
                            confirmTitle: "確認")
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func clickBtnLogout() {
        Task {
            await callApiLogout()
        }
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag.isEqual(to: 0) {
            return 6
        } else {
            return concentrateRecordList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag.isEqual(to: 0) {
            switch indexPath.row {
            case 0:
                guard let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalLabelTableViewCell.identifier,
                                                                for: indexPath) as? PersonalLabelTableViewCell else {
                    fatalError("PersonalLabelTableViewCell Load Failed")
                }
                cell.title.text = tvTitleAry[indexPath.row]
                cell.value.text = UserPreferences.shared.email
                return cell
            case 1:
                guard let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalLabelTableViewCell.identifier,
                                                                for: indexPath) as? PersonalLabelTableViewCell else {
                    fatalError("PersonalLabelTableViewCell Load Failed")
                }
                cell.title.text = tvTitleAry[indexPath.row]
                cell.value.text = UserPreferences.shared.dor
                return cell
            case 2:
                guard let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identifier,
                                                                for: indexPath) as? PersonalTableViewCell else {
                    fatalError("PersonalTableViewCell Load Failed")
                }
                cell.title.text = tvTitleAry[indexPath.row]
                return cell
            case 3:
                guard let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identifier,
                                                                for: indexPath) as? PersonalTableViewCell else {
                    fatalError("PersonalTableViewCell Load Failed")
                }
                cell.title.text = tvTitleAry[indexPath.row]
                return cell
            case 4:
                guard let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identifier,
                                                                for: indexPath) as? PersonalTableViewCell else {
                    fatalError("PersonalTableViewCell Load Failed")
                }
                cell.title.text = tvTitleAry[indexPath.row]
                return cell
            default:
                guard let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identifier,
                                                                for: indexPath) as? PersonalTableViewCell else {
                    fatalError("PersonalTableViewCell Load Failed")
                }
                cell.title.text = tvTitleAry[indexPath.row]
                return cell
            }
        } else {
            if indexPath.row.isEqual(to: concentrateRecordList.count - 1) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstConcentrateRecordTableViewCell.identifier,
                                                               for: indexPath) as? FirstConcentrateRecordTableViewCell else {
                    fatalError("FirstConcentrateRecordTableViewCell Load Failed")
                }
                if concentrateRecordList[indexPath.row].isFinished == true {
                    cell.imgvStatus.image = UIImage(systemIcon: .checkmark)
                    cell.vStatusCircle.backgroundColor = .buttom2Color
                    cell.vStatusStrip.backgroundColor = .buttom2Color
                } else {
                    cell.imgvStatus.image = UIImage(systemIcon: .multiply)
                    cell.vStatusCircle.backgroundColor = .cancel
                    cell.vStatusStrip.backgroundColor = .cancel
                }
                
                var withFriends: String = "好友： "
                if concentrateRecordList[indexPath.row].accountId != concentrateRecordList[indexPath.row].hostAccountId {
                    withFriends.append("\(concentrateRecordList[indexPath.row].hostAccountId), ")
                }
                for i in 0 ..< concentrateRecordList[indexPath.row].withFriends.count {
                    if i == concentrateRecordList[indexPath.row].withFriends.count - 1 {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i])")
                    } else {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i]), ")
                    }
                }
                cell.lbConcentrateTime.text = "\(concentrateRecordList[indexPath.row].startTime)"
                cell.lbConcentrateRecord.text = "專注時間： \(concentrateRecordList[indexPath.row].concentrateTime)   休息時間：\(concentrateRecordList[indexPath.row].restTime)"
                if withFriends.isEqual(to: "好友： ") {
                    withFriends = "單人模式"
                }
                cell.lbConcentrateWith.text = withFriends
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ConcentrateRecordTableViewCell.identifier,
                                                               for: indexPath) as? ConcentrateRecordTableViewCell else {
                    fatalError("ConcentrateRecordTableViewCell Load Failed")
                }
                if concentrateRecordList[indexPath.row].isFinished == true {
                    cell.imgvStatus.image = UIImage(systemIcon: .checkmark)
                    cell.vStatusCircle.backgroundColor = .buttom2Color
                    cell.vStatusStrip.backgroundColor = .buttom2Color
                } else {
                    cell.imgvStatus.image = UIImage(systemIcon: .multiply)
                    cell.vStatusCircle.backgroundColor = .cancel
                    cell.vStatusStrip.backgroundColor = .cancel
                }
                
                var withFriends: String = "好友： "
                if concentrateRecordList[indexPath.row].accountId != concentrateRecordList[indexPath.row].hostAccountId {
                    withFriends.append("\(concentrateRecordList[indexPath.row].hostAccountId), ")
                }
                for i in 0 ..< concentrateRecordList[indexPath.row].withFriends.count {
                    if i == concentrateRecordList[indexPath.row].withFriends.count - 1{
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i])")
                    } else {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i]), ")
                    }
                    
                }
                cell.lbConcentrateTime.text = "\(concentrateRecordList[indexPath.row].startTime)"
                cell.lbConcentrateRecord.text = "專注時間： \(concentrateRecordList[indexPath.row].concentrateTime)   休息時間：\(concentrateRecordList[indexPath.row].restTime)"
                if withFriends.isEqual(to: "好友： ") {
                    withFriends = "單人模式"
                }
                cell.lbConcentrateWith.text = withFriends
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag.isEqual(to: 1) {
            let nextVC = ConcentrateRecordViewController()
            nextVC.timeTitle = "\(concentrateRecordList[indexPath.row].startTime) 的專注歷程"
            nextVC.recordId = concentrateRecordList[indexPath.row].recordId.uuidString
            self.present(nextVC, animated: true)
        } else {
            if indexPath.row.isEqual(to: 2) {
                let nextVC = MyPostViewController()
                var btn = UIBarButtonItem()
                self.navigationController?.navigationBar.topItem?.backBarButtonItem = btn
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

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
        Task {
            await callApiUploadImage(imageString: imageString!)
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - Protocol
