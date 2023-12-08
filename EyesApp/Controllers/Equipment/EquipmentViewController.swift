//
//  EquipmentViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import AVFoundation
import UIKit

class EquipmentViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lightView: UIView!
    @IBOutlet weak var blueDetectionView: UIView!
    @IBOutlet weak var ivgLight: UIImageView!
    @IBOutlet weak var ivgBlueDetection: UIView!
    @IBOutlet weak var lightSlider: UISlider!
    @IBOutlet weak var lbBlueLightValue: UILabel!
    @IBOutlet weak var btnBlueLightDetection: UIButton!
    
    // MARK: - Properties
    
    var changeBackgroundValue: CGFloat?
    var changeImageValueR: CGFloat?
    var changeImageValueG: CGFloat?
    var changeImageValueB: CGFloat?
    var blueLightStatus = false
    
    private let bluetooth = BluetoothServices.shared
    
    private let captureSession = AVCaptureSession()
    private let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                      for: .video,
                                                      position: .front)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBlueServices()
        Alert.showAlert(title: "提示",
                        message: "使用前請先確認檯燈藍牙狀態燈亮起，以及藍光感測器已通電",
                        vc: self,
                        confirmTitle: "確認")
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
        setupImageView()
        setupEquipmentView()
    }
    
    fileprivate func setupImageView() {
        if #available(iOS 16.0, *) {
            ivgLight.image = UIImage(systemIcon: .lampDesk)
        } else {
            ivgLight.image = UIImage(systemIcon: .lightbulb)
        }
    }
    
    fileprivate func setupEquipmentView() {
        lightView.layer.cornerRadius = 20
        lightView.layer.shadowOffset = CGSize(width: 5, height: 5)
        lightView.layer.shadowOpacity = 0.1
        lightView.layer.shadowRadius = 20
        
        blueDetectionView.layer.cornerRadius = 20
        blueDetectionView.layer.shadowOffset = CGSize(width: 5, height: 5)
        blueDetectionView.layer.shadowOpacity = 0.1
        blueDetectionView.layer.shadowRadius = 20
    }
    
    fileprivate func changeColor() {
        changeBackgroundValue = CGFloat(lightSlider.value / 100) * 0.5
        changeImageValueR = 0.23137 / CGFloat(lightSlider.value / 100)
        changeImageValueG = 0.49411 / CGFloat(lightSlider.value / 100)
        changeImageValueB = 0.203921 / CGFloat(lightSlider.value / 100)
    }
    
    // MARK: - Bluetooth Service
    
    func setupBlueServices() {
        bluetooth.delegate = self
        if Bluelight.peripheral != nil {
            bluetooth.connectPeripheral(peripheral: Bluelight.peripheral!)
        }
    }
    
    func isoValue(vc: UIViewController) {
        if Lamp.peripheral == nil {
            Alert.showAlert(title: "裝置",
                            message: "未搜尋到對應裝置，請確認裝置狀態或重新啟動",
                            vc: vc,
                            confirmTitle: "確認")
        } else {
            bluetooth.connectPeripheral(peripheral: Lamp.peripheral!)
            
            let data = "C".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
            print("C")
        }
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: AddMissionComplete
    
    func callApiAddMissionComplete(missionId: String,
                                   accountId: String,
                                   date: String) async {
        let request = AddMissionCompleteRequest(missionId: UUID(uuidString: missionId)!,
                                                accountId: UUID(uuidString: accountId)!,
                                                date: date)
        do {
            let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                              path: .addMissionComplete,
                                                                                              parameters: request,
                                                                                              needToken: true)
            if result.message.isEqual(to: "沒有此任務") {
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
    
    // 電燈開關放這裡
    @IBAction func clickbtnLight() {
        if Lamp.peripheral == nil {
            Alert.showAlert(title: "裝置",
                            message: "未搜尋到對應裝置，請確認裝置狀態或重新啟動",
                            vc: self,
                            confirmTitle: "確認")
        } else {
            bluetooth.connectPeripheral(peripheral: Lamp.peripheral!)
        }
        
        if lightSlider.isHidden == false {
            let data = "B".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        } else {
            let data = "A".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        }
    }
    
    // 調亮度放這裡
    @IBAction func slideLight() {
        print(lightSlider.value)
        changeColor()
        lightView.backgroundColor = UIColor(hue: 0.35,
                                            saturation: 0.75,
                                            brightness: 0.49 + CGFloat(changeBackgroundValue!),
                                            alpha: 1)
        ivgLight.tintColor = UIColor(red: changeImageValueR!,
                                     green: changeImageValueG!,
                                     blue: changeImageValueB!, alpha: 1)
        
        let step: Float = 20
        lightSlider.value = (lightSlider.value / step).rounded() * step
        
        switch lightSlider.value {
        case 100:
            let data = "5".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        case 80:
            let data = "4".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        case 60:
            let data = "3".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        case 40:
            let data = "2".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        case 20:
            let data = "1".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        case 0:
            let data = "0".data(using: .utf8)
            bluetooth.writeValue(type: .withoutResponse, data: data!)
        default:
            break
        }
    }
    
    @IBAction func clickLightBtn() {
        if #available(iOS 16.0, *) {
            if lightSlider.isHidden == false {
                lightSlider.isHidden = true
                ivgLight.image = UIImage(systemIcon: .lampDesk)
                lightView.backgroundColor = UIColor.buttomColor
                ivgLight.tintColor = .white
            } else {
                lightSlider.isHidden = false
                ivgLight.image = UIImage(systemIcon: .lampDeskFill)
            }
        } else {
            if lightSlider.isHidden == false {
                lightSlider.isHidden = true
                ivgLight.image = UIImage(systemIcon: .lightbulb)
                lightView.backgroundColor = UIColor.buttomColor
                ivgLight.tintColor = .white
            } else {
                lightSlider.isHidden = false
                ivgLight.image = UIImage(systemIcon: .lightbulbFill)
            }
        }
    }
    
    @IBAction func blueLightBtnClick() {
        blueLightStatus.toggle()
        if blueLightStatus == true {
            lbBlueLightValue.isHidden = false
            blueDetectionView.backgroundColor = .buttom2Color
        } else {
            lbBlueLightValue.isHidden = true
            blueDetectionView.backgroundColor = .buttomColor
        }
    }
}

// MARK: - BluetoothServicesDelegate

extension EquipmentViewController: BluetoothServicesDelegate {
    
    func getBLEPeripheralValue(value: Int) {
        DispatchQueue.main.async {
            self.lbBlueLightValue.text = "藍光度數：\(value) %"
            if self.blueLightStatus == true {
                if value >= 65 {
                    Alert.showAlert(title: "藍光",
                                    message: "藍光過高，請注意眼睛健康",
                                    vc: self,
                                    confirmTitle: "確認")
                } else {
                    let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
                    Task {
                        await self.callApiAddMissionComplete(missionId: UserPreferences.shared.blueLightMissionId,
                                                             accountId: UserPreferences.shared.accountId,
                                                             date: now)
                        Thread.sleep(forTimeInterval: 0.5)
                    }
                }
            }
        }
    }
}

// MARK: - Protocol
