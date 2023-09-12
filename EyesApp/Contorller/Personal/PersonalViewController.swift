//
//  PersonalViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit

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
        callGetPersonInformationApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PersonalViewController")
        
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
        igvUser.layer.cornerRadius = igvUser.frame.width / 2.1
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
                                                                                               parameters: request)
                print(response)
            
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
                                                                      parameters: request)
                UserPreferences.shared.dor = response.data!.dor
                UserPreferences.shared.email = response.data!.email
                UserPreferences.shared.name = response.data!.name
                let imageString = response.data!.image
                let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
                let image = base64ToImage(imageData: imageData)
                igvUser.image = image
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func clickBtnLogout() {
        UserPreferences.shared.resetInitialFlowVarables()
        let nextVC = LoginViewController()
        navigationController?.pushViewController(nextVC, animated: true)
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
        if indexPath.row < 2 {
            let cell = tvPersonal.dequeueReusableCell(withIdentifier: PersonalLabelTableViewCell.identified,
                                                      for: indexPath) as! PersonalLabelTableViewCell
            cell.title.text = tvTitleArry[indexPath.row]
            cell.value.text = AppDefine.userName
            return cell
        } else {
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
        let imageString = imageToBase64(image: image!)
        print("=================================")
        print("\(imageString)")
        print("=================================")
        callUploadImageApi(imageString: imageString)
        picker.dismiss(animated: true)
    }
    
    func imageToBase64(image: UIImage) -> String {
        let imageData: Data? = image.jpegData(compressionQuality: 0.1)
        let str: String = imageData!.base64EncodedString()
        //返回
        return str
    }
    
    func base64ToImage(imageData: Data?) -> UIImage {
        let uiimage: UIImage = UIImage.init(data: imageData!)!
        return uiimage
    }
   
}


// MARK: - Protocol
