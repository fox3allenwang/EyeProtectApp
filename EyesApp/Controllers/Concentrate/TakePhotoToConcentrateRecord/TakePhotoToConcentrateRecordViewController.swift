//
//  TakePhotoToConcentrateRecordViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/31.
//

import Lottie
import UIKit

class TakePhotoToConcentrateRecordViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvPicture: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnTakePicture: UIButton!
    @IBOutlet weak var txvNote: UITextView!
    @IBOutlet weak var vImageBaclground: UIView!
    @IBOutlet weak var vAnimateBackground: UIView!
    
    // MARK: - Properties
    
    let imagePicker = UIImagePickerController()
    var pictureImage: UIImage? = nil
    var inviteRoomId = ""
    var recordId = ""
    var concentrateType: AlongOrMutiple = .along
    var concentrateRecordId: String? = nil
    
    enum AlongOrMutiple {
        
        case along
        
        case mutiple
    }
    
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
    
    fileprivate func setupUI() {
        setupPictureImgeView()
        setupButtonUI()
        setupImageBaclgroundView()
        setupNoteTextView()
    }
    
    fileprivate func setupPictureImgeView() {
        imgvPicture.contentMode = .scaleAspectFit
        imgvPicture.image = pictureImage
    }
    
    fileprivate func setupButtonUI() {
        btnConfirm.layer.cornerRadius = 20
        btnConfirm.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnConfirm.layer.shadowOpacity = 0.2
        btnConfirm.layer.shadowRadius = 10
        
        btnCancel.layer.cornerRadius = 20
        btnCancel.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnCancel.layer.shadowOpacity = 0.2
        btnCancel.layer.shadowRadius = 10
    }
    
    fileprivate func setupImageBaclgroundView() {
        vImageBaclground.layer.cornerRadius = 20
        vImageBaclground.layer.shadowOffset = CGSize(width: 0, height: 5)
        vImageBaclground.layer.shadowOpacity = 0.2
        vImageBaclground.layer.shadowRadius = 10
    }
    
    fileprivate func setupNoteTextView() {
        txvNote.text = "描述你的專注歷程..."
        txvNote.delegate = self
        txvNote.layer.borderColor = UIColor.buttomColor.cgColor
        txvNote.layer.borderWidth = 2
        txvNote.layer.cornerRadius = 10
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: UploadAlongRecordImage
    
    func callApiUploadAlongRecordImage(recordId: String,
                                       image: String,
                                       description: String,
                                       finish: ((String) -> Void)? = nil) {
        let request = UploadAlongRecordImageRequest(recordId: UUID(uuidString: recordId)!,
                                                    image: image,
                                                    description: description)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .uploadAlongRecordImage,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "更新成功") {
                    finish?(result.data)
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
    }
    
    // MARK: UploadMtipleRecordImageRequest
    
    func callApiUploadMtipleRecordImageRequest(inviteRoomId: String,
                                               accountId: String,
                                               image: String,
                                               description: String,
                                               finish: ((String) -> Void)? = nil) {
        let request = UploadMtipleRecordImageRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                     accountId: UUID(uuidString: accountId)!,
                                                     image: image,
                                                     description: description)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .uploadMtipleRecordImage,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "更新成功") {
                    finish?(result.data)
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
    }
    
    // MARK: AddConcentrateToNews
    
    func callApiAddConcentrateToNews(concentrateRecordId: String, finish: (() -> Void)? = nil) {
        let request = AddConcentrateToNewsRequest(concentrateRecordId: UUID(uuidString: concentrateRecordId)!)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addConcentrateToNews,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "發送成功") {
                    finish?()
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
    }
    
    // MARK: - IBAction
    
    @IBAction func clickCancelButton() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func takePictureAgain() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func clickConfirm() {
        var description = ""
        
        if txvNote.textColor == .black {
            description = txvNote.text
        }
        
        guard let image = imgvPicture.image else {
            return
        }
        
        if concentrateType == .along {
            callApiUploadAlongRecordImage(recordId: recordId,
                                          image: image.imageToBase64(),
                                          description: description) { recordId in
                Alert.showAlert(title: "上傳成功",
                                message: "",
                                vc: self,
                                confirmTitle: "確認") {
                    Alert.showAlert(title: "要分享到朋友圈嗎？",
                                    message: "",
                                    vc: self,
                                    confirmTitle: "要",
                                    cancelTitle: "不要") {
                        // 存資料到朋友圈
                        self.concentrateRecordId = recordId
                        self.callApiAddConcentrateToNews(concentrateRecordId: self.concentrateRecordId!) {
                            Alert.showAlert(title: "分享成功",
                                            message: "",
                                            vc: self,
                                            confirmTitle: "確認") {
                                self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                            }
                        }
                    } cancel: {
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }
                }
            }
        } else {
            callApiUploadMtipleRecordImageRequest(inviteRoomId: inviteRoomId,
                                                  accountId: UserPreferences.shared.accountId,
                                                  image: image.imageToBase64(),
                                                  description: description) { recordId in
                Alert.showAlert(title: "上傳成功",
                                message: "",
                                vc: self,
                                confirmTitle: "確認") {
                    Alert.showAlert(title: "要分享到朋友圈嗎？",
                                    message: "",
                                    vc: self,
                                    confirmTitle: "要",
                                    cancelTitle: "不要") {
                        // 存資料到朋友圈
                        self.concentrateRecordId = recordId
                        self.callApiAddConcentrateToNews(concentrateRecordId: self.concentrateRecordId!) {
                            Alert.showAlert(title: "分享成功",
                                            message: "",
                                            vc: self,
                                            confirmTitle: "確認") {
                                self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                            }
                        }
                    } cancel: {
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension TakePhotoToConcentrateRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let image = info[.originalImage] as? UIImage
            self.imgvPicture.image = image
        }
    }
}

// MARK: - UITextViewDelegate

extension TakePhotoToConcentrateRecordViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "在這裡描述你的專注歷程..."
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}

// MARK: - Protocol

