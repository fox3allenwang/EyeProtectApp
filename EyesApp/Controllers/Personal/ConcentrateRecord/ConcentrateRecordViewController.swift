//
//  ConcentrateRecordViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import ProgressHUD
import UIKit

class ConcentrateRecordViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvPicture: UIImageView!
    @IBOutlet weak var txvNote: UITextView!
    @IBOutlet weak var vImageBaclground: UIView!
    @IBOutlet weak var vBlackStrip: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Properties
    
    var pictureImage: UIImage?
    var timeTitle: String = ""
    var recordId: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        Task {
            await callApiFindConcentrateRecordByRecordId(recordId: recordId)
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
        setupPictureImgeView()
        setupImageBaclgroundView()
        setupNoteTextView()
        setupBlackStrip()
        lbTitle?.text = timeTitle
    }
    
    fileprivate func setupPictureImgeView() {
        imgvPicture.contentMode = .scaleAspectFit
        imgvPicture.image = pictureImage
    }
    
    fileprivate func setupImageBaclgroundView() {
        vImageBaclground.layer.cornerRadius = 20
        vImageBaclground.layer.shadowOffset = CGSize(width: 0, height: 5)
        vImageBaclground.layer.shadowOpacity = 0.2
        vImageBaclground.layer.shadowRadius = 10
    }
    
    fileprivate func setupBlackStrip() {
        vBlackStrip.layer.cornerRadius = 2
    }
    
    fileprivate func setupNoteTextView() {
        txvNote.layer.borderColor = UIColor.buttomColor.cgColor
        txvNote.layer.borderWidth = 2
        txvNote.layer.cornerRadius = 10
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: FindConcentrateRecordByRecordId
    
    func callApiFindConcentrateRecordByRecordId(recordId: String) async {
        let request = FindConcentrateRecordByRecordIdRequest(recordId: UUID(uuidString: recordId)!)
        do {
            let result: GeneralResponse<FindConcentrateRecordByRecordIdResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                               path: .findConcentrateRecordByRecordId,
                                                                                                                               parameters: request,
                                                                                                                               needToken: true)
            
            if result.message.isEqual(to: "找到 ConcentrateRecord 了") {
                if result.data.picture.isEqual(to: "未上傳") {
                    imgvPicture.image = UIImage(systemIcon: .photoOnRectangleAngled)
                    if !result.data.description.isEmpty {
                        txvNote.text = result.data.description
                        txvNote.textColor = .black
                    }
                } else {
                    imgvPicture.image = result.data.picture.stringToUIImage()
                    if !result.data.description.isEmpty {
                        txvNote.text = result.data.description
                        txvNote.textColor = .black
                    }
                }
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
    
}

// MARK: - Extensions

// MARK: - Protocol

