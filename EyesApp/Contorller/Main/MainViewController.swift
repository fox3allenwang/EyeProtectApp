//
//  MainViewController.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/9.
//

import UIKit
import WebKit
import AVFoundation

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lightLevelLabel: UILabel!
    @IBOutlet weak var manualLabel: UILabel!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var oneLevelButton: UIButton!
    @IBOutlet weak var twoLevelButton: UIButton!
    @IBOutlet weak var threeLevelButton: UIButton!
    @IBOutlet weak var isoLabel: UILabel!
    @IBOutlet weak var web: WKWebView!
    
    // MARK: - Property／Variables
    
    private var timer: Timer?
    private var timer1: Timer?
    private var count = 0
    private var timerCurrentCount = 0
    private var isOn = 0
    private var senderIsOn = false
    private var isoTmpArray: [Int] = []
    
    private let captureSession = AVCaptureSession()
    
    // 設置前鏡頭
    private let frontedCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    // 設置後鏡頭
    private let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        self.timer = Timer.scheduledTimer(timeInterval: 15,
                                          target: self,
                                          selector: #selector(handleTimerExecution),
                                          userInfo: nil,
                                          repeats: true)
        self.timer1 = Timer.scheduledTimer(timeInterval: 90,
                                           target: self,
                                           selector: #selector(handleTimerExecution1),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    // MARK: - UI Settings
    
    private func setupUI() {
        setupLabel()
        setupButton()
        setupSlider()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "護眼 App"
    }
    
    func setupLabel() {
        lightLevelLabel.text = "檯燈亮度\n關"
        lightLevelLabel.backgroundColor = UIColor(red: 240/255, green: 228/255, blue: 215/255, alpha: 1)
        lightLevelLabel.layer.cornerRadius = 10
        lightLevelLabel.layer.masksToBounds = true
        isoLabel.backgroundColor = UIColor(red: 209/255, green: 223/255, blue: 232/255, alpha: 1)
        isoLabel.layer.cornerRadius = 10
        isoLabel.layer.masksToBounds = true
        
        manualLabel.backgroundColor = UIColor(red: 213/255, green: 203/255, blue: 142/255, alpha: 1)
        manualLabel.layer.cornerRadius = 10
        manualLabel.layer.masksToBounds = true
        
        isoLabel.text = "環境亮度偵測中"
        manualLabel.text = "手動模式"
    }
    
    func setupButton() {
        offButton.setTitle("關", for: .normal)
        oneLevelButton.setTitle("1", for: .normal)
        twoLevelButton.setTitle("2", for: .normal)
        threeLevelButton.setTitle("3", for: .normal)
        offButton.tag = 0
        oneLevelButton.tag = 1
        twoLevelButton.tag = 2
        threeLevelButton.tag = 3
    }
    
    func setupSlider() {
        
    }
    
    // MARK: - Function
    
    private func setupCamera() {
        // 添加輸入設備至捕捉會話中
        guard let frontedCamera = frontedCamera,
              let frontedCameraInput = try? AVCaptureDeviceInput(device: frontedCamera) else {
            return
        }
        captureSession.addInput(frontedCameraInput)
        
        // 添加影片輸出到捕捉會話中
        let captureVideoOutput = AVCaptureVideoDataOutput()
        //記錄影片並提供對影片幀進行處理的訪問的捕獲輸出。
        captureSession.addOutput(captureVideoOutput)
        captureVideoOutput.setSampleBufferDelegate(self,
                                                   queue: DispatchQueue(label: "sample buffer delegate"))
        // 開始捕捉會話
        captureSession.startRunning()
    }
    
    @objc private func handleTimerExecution() {
        captureSession.startRunning()
        print("timer stop")
    }
    
    @objc private func handleTimerExecution1() {
        Alert.showAlert(title: "提醒",
                        message: "用眼30分鐘需休息",
                        vc: self,
                        confirmTitle: "確認") {
            if let timer = self.timer1 {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func levelBtnClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let url = URL(string: "http://192.168.4.1/led/0")
            let urlReq = URLRequest(url: url!)
            self.web?.load(urlReq)
            lightLevelLabel.text = "檯燈亮度\n關"
        case 1:
            let url=URL(string: "http://192.168.4.1/led/1")
            let urlreq=URLRequest(url: url!)
            self.web?.load(urlreq)
            lightLevelLabel.text = "檯燈亮度\n低"
        case 2:
            let url=URL(string: "http://192.168.4.1/led/2")
            let urlreq=URLRequest(url: url!)
            self.web?.load(urlreq)
            lightLevelLabel.text = "檯燈亮度\n中"
        case 3:
            let url=URL(string: "http://192.168.4.1/led/3")
            let urlreq=URLRequest(url: url!)
            self.web?.load(urlreq)
            lightLevelLabel.text = "檯燈亮度\n高"
        default:
            break
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            // self.isoLabel.text = "ISO: \(self.frontedCamera?.iso ?? 0)"
            self.isoLabel.text = "環境亮度偵測中"
            print("ISO: \(self.frontedCamera?.iso ?? 0)")
            if (self.count % 50 == 0 && self.count != 0) {
                self.isoTmpArray.append(Int(self.frontedCamera!.iso))
            }
            if self.count == 200 {
                print(self.isoTmpArray)
                let now = Date()
                LocalDatabase.shared.timeRecord.append(now)
                LocalDatabase.shared.statusRecord.append(self.isoTmpArray.reduce(0, +)/self.isoTmpArray.count)
                print(LocalDatabase.shared.timeRecord)
                
                // LocalDatabase.shared.updateRecord(timeRecord: self.timeRecord, statusRecord: self.statusRecord)
                self.count = 0
                self.isoTmpArray.removeAll()
                if LocalDatabase.shared.statusRecord[LocalDatabase.shared.statusRecord.count - 1] < 100 {
                    self.isoLabel.text = "目前環境亮度充足"
                    let url=URL(string: "http://192.168.4.1/led/0")
                    DispatchQueue.main.async {
                        let urlreq=URLRequest(url: url!)
                        self.web.load(urlreq)
                        self.lightLevelLabel.text = "關"
                    }
                } else if (LocalDatabase.shared.statusRecord[LocalDatabase.shared.statusRecord.count - 1] < 200 && LocalDatabase.shared.statusRecord[LocalDatabase.shared.statusRecord.count - 1] >= 100) {
                    self.isoLabel.text = "目前環境亮度稍弱"
                    let url = URL(string: "http://192.168.4.1/led/1")
                    let urlReq = URLRequest(url: url!)
                    DispatchQueue.main.async {
                        self.web.load(urlReq)
                        self.lightLevelLabel.text = "亮度低"
                    }
                } else if (LocalDatabase.shared.statusRecord[LocalDatabase.shared.statusRecord.count - 1] < 300 && LocalDatabase.shared.statusRecord[LocalDatabase.shared.statusRecord.count - 1] >= 200) {
                    self.isoLabel.text = "目前環境亮度弱"
                    let url = URL(string: "http://192.168.4.1/led/2")
                    let urlReq = URLRequest(url: url!)
                    DispatchQueue.main.async {
                        self.web?.load(urlReq)
                        self.lightLevelLabel.text = "亮度中"
                    }
                    Alert.showAlert(title: "提醒",
                                    message: "環境亮度不足",
                                    vc: self,
                                    confirmTitle: "確認")
                } else if (LocalDatabase.shared.statusRecord[LocalDatabase.shared.statusRecord.count - 1] > 300) {
                    self.isoLabel.text = "目前環境亮度嚴重不足"
                    let url = URL(string: "http://192.168.4.1/led/3")
                    let urlReq = URLRequest(url: url!)
                    DispatchQueue.main.async {
                        self.web?.load(urlReq)
                        self.lightLevelLabel.text = "亮度高"
                    }
                    Alert.showAlert(title: "提醒",
                                    message: "環境亮度嚴重不足",
                                    vc: self,
                                    confirmTitle: "確認")
                }
                
                self.captureSession.stopRunning()
            }
            print(self.count)
            self.count += 1
        }
        
        // 依 iso 數值及手電筒狀態是否關閉或開啟手電筒
        if let frontedCamera = frontedCamera {
            if (frontedCamera.iso < 100 && isOn != 0 ) {
                isOn = 0
            } else if (frontedCamera.iso < 200 && frontedCamera.iso >= 100 && isOn != 1) {
                
                isOn = 1
            } else if (frontedCamera.iso < 300 && frontedCamera.iso >= 200 && isOn != 2) {
                
                isOn = 2
            } else if (frontedCamera.iso >= 300 && isOn != 3) {
                
                isOn = 3
            }
        }
    }
}


