//
//  TakePhotoToConcentrateRecordViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/31.
//

import UIKit
import Lottie

class TakePhotoToConcentrateRecordViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvPicture: UIImageView?
    @IBOutlet weak var btnConfirm: UIButton?
    @IBOutlet weak var btnCancel: UIButton?
    @IBOutlet weak var btnTakePicture: UIButton?
    @IBOutlet weak var txvNote: UITextView?
    @IBOutlet weak var vImageBaclground: UIView?
    @IBOutlet weak var vAnimateBackground: UIView?
    
    // MARK: - Variables
    
    let imagePicker = UIImagePickerController()
    var pictureImage: UIImage? = nil
    var inviteRoomId = ""
    var recordId = ""
    var concentrateType: alongOrMutiple = .along
    
    enum alongOrMutiple {
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
    
    func setupUI() {
        setupPictureImgeView()
        setupButtonUI()
        setupImageBaclgroundView()
        setupNoteTextView()
//        setupBackgroundAnimate()
    }
    
    func setupPictureImgeView() {
        imgvPicture?.contentMode = .scaleAspectFit
        imgvPicture?.image = pictureImage
    }
    
    func setupButtonUI() {
        btnConfirm?.layer.cornerRadius = 20
        btnConfirm?.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnConfirm?.layer.shadowOpacity = 0.2
        btnConfirm?.layer.shadowRadius = 10
        
        btnCancel?.layer.cornerRadius = 20
        btnCancel?.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnCancel?.layer.shadowOpacity = 0.2
        btnCancel?.layer.shadowRadius = 10
    }
    
    func setupImageBaclgroundView() {
        vImageBaclground?.layer.cornerRadius = 20
        vImageBaclground?.layer.shadowOffset = CGSize(width: 0, height: 5)
        vImageBaclground?.layer.shadowOpacity = 0.2
        vImageBaclground?.layer.shadowRadius = 10
    }
    
    func setupNoteTextView() {
        txvNote?.text = "描述你的專注歷程..."
        txvNote?.delegate = self
        txvNote?.layer.borderColor = UIColor.buttomColor?.cgColor
        txvNote?.layer.borderWidth = 2
        txvNote?.layer.cornerRadius = 10
    }
    
//    func setupBackgroundAnimate() {
//        let vAnimate = LottieAnimationView(name: "dotsBackground")
//        vAnimate.contentMode = .scaleAspectFill
//        vAnimate.frame = CGRect(x: 0,
//                                   y: 0,
//                                   width: CGFloat((vAnimateBackground?.frame.width)!),
//                                   height: CGFloat((vAnimateBackground?.frame.height)!))
//        vAnimate.center = CGPoint(x: vAnimateBackground!.bounds.width * 0.5,
//                                  y: vAnimateBackground!.bounds.height * 0.5)
//        vAnimate.loopMode = .loop
//        vAnimate.animationSpeed = 1
//        vAnimateBackground!.addSubview(vAnimate)
//        vAnimate.play()
//    }
    
    // MARK: - callAPIUploadAlongRecordImage
    
    func callApiUploadAlongRecordImage(recordId: String,
                                       image: String,
                                       description: String,
                                       completionHandler: (() -> Void)? = nil) {
        let request = UploadAlongRecordImageRequest(recordId: UUID(uuidString: recordId)!,
                                                    image: image,
                                                    description: description)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .uploadAlongRecordImage,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.message == "更新成功" {
                    completionHandler?()
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
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePictureAgain() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func clickConfirm() {
        if concentrateType == .along {
            var description = ""
            
            if txvNote?.textColor == UIColor.black {
                description = (txvNote?.text)!
            }
            
            callApiUploadAlongRecordImage(recordId: recordId,
                                          image: (imgvPicture?.image?.imageToBase64())!,
                                          description: description) {
                Alert.showAlert(title: "上傳成功", message: "", vc: self, confirmTitle: "確認") {
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

}

// MARK: - ImagePickerControllerDelegate

extension TakePhotoToConcentrateRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let image = info[.originalImage] as? UIImage
            self.imgvPicture?.image = image
        }
    }
}

// MARK: - UITextViewDelegate

extension TakePhotoToConcentrateRecordViewController: UITextViewDelegate {
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "在這裡描述你的專注歷程..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

// MARK: - Protocol

