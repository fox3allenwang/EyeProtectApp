//
//  FatigueDetectionViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/6.
//

import ARKit
import AVFoundation
import CoreML
import UIKit

class FatigueDetectionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vARSCN: ARSCNView!
    @IBOutlet weak var vAlertBackground: UIView!
    @IBOutlet weak var swAlert: UISwitch!
    
    // MARK: - Properties
    
    var result = ""
    var count = 0
    var fatigue = 0
    var noneFatigue = 0
    var fatigueArray: [Float] = []
    var ARText = SCNText(string: "", extrusionDepth: 2)
    var backToStartConcentrateDelegate: FatigueDetectionBackToStartConcentrateVCDelegate?
    var backToMainVCDelegate: FatigueDetectionBackToMainVCDelegate?
    var openOrCloseEyeRequests = [VNRequest]()
    var openOrCloseStatus = 0 // 0 是 open
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fatigue Detection"
        setupUI()
        
        Task {
            let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
            await callApiAddMissionComplete(missionId: UserPreferences.shared.fatigueMissionId,
                                      accountId: UserPreferences.shared.accountId,
                                      date: now)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backToStartConcentrateDelegate?.transformUI()
        backToMainVCDelegate?.startCatchISO()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        setupARSCNView()
        setupAlertBackgroun()
        setupVision()
    }
    
    fileprivate func setupARSCNView() {
        vARSCN.delegate = self
        let config = ARFaceTrackingConfiguration()
        vARSCN.session.run(config)
    }
    
    fileprivate func setupAlertBackgroun() {
        vAlertBackground.layer.cornerRadius = 20
        vAlertBackground.clipsToBounds = true
    }
    
    @discardableResult
    fileprivate func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError? = nil
        
        guard let modelURL = Bundle.main.url(forResource: "OpenEyeAndCloseEye 0.87 loss",
                                             withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController",
                           code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel) { result in
                switch result {
                case .success(let request):
                    DispatchQueue.main.async {
                        if let results = request.results {
                            self.countOpenOrCloseEyeRequestResults(results)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            openOrCloseEyeRequests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        return error
    }
    
    // MARK: - Functions
    
    func countOpenOrCloseEyeRequestResults(_ results: [Any]) {
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            if topLabelObservation.confidence > 0.9 {
                if topLabelObservation.identifier == "closed eye" {
                    openOrCloseStatus = 1
                } else {
                    openOrCloseStatus = 0
                }
            }
        }
    }
    
    // MARK: - Call Backend RESTful API
    
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
                if result.message == "沒有此任務" {
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
    
    @IBAction func switchAlertStatus() {
        if swAlert.isOn == true {
            Alert.showAlert(title: "啟用警示音", 
                            message: "在使用前請確保靜音模式已關閉，打開以後睡意值在 70% 以上會響鈴並警告",
                            vc: self,
                            confirmTitle: "啟用",
                            cancelTitle: "取消") {
                //
            } cancel: {
                self.swAlert.isOn = false
            }
        }
    }
}

// MARK: - ARSCNViewDelegate

extension FatigueDetectionViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: vARSCN.device!)
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.buttom2Color // 設置文字顏色
        
        ARText.materials = [material]
        let textNode = SCNNode()
        textNode.geometry = ARText
        textNode.position.z = node.boundingBox.max.z * 3 / 4
        textNode.position.y = 0.1
        textNode.position.x = -0.08
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        
        node.addChildNode(textNode)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, 
           let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
            guard let pixelBuffer = self.vARSCN.session.currentFrame?.capturedImage else {
                return
            }
            
            do {
                let modelConfigration = MLModelConfiguration()
                let model = try FatigueDetection_New__Test_76_ACC(configuration: modelConfigration)
                let input = FatigueDetection_New__Test_76_ACCInput(image: pixelBuffer)
                let output = try model.prediction(input: input)
                
                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                                orientation: .right,
                                                                options: [:])
                do {
                    try imageRequestHandler.perform(self.openOrCloseEyeRequests)
                } catch {
                    print(error)
                }
               
                let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft]
                let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight]
                let jawOpen = faceAnchor.blendShapes[.jawOpen]
                
                var activeProbs = output.classLabelProbs.first!.value
                if ((eyeBlinkLeft?.decimalValue ?? 0.0) + (eyeBlinkRight?.decimalValue ?? 0.0)) > 0.8 {
                    activeProbs -= 0.2
                } else {
                    activeProbs += 0.26
                }

                if (jawOpen?.decimalValue ?? 0.0) > 0.5 {
                    activeProbs -= 0.1
                }
                
                if openOrCloseStatus == 0 {
                    activeProbs += 0.1
                } else {
                    activeProbs -= 0.1
                }

                fatigueArray.append(Float(activeProbs))
                count += 1

                if count == 20 {
                    var result = fatigueArray.average
                    DispatchQueue.main.async {
                        if result < 0 {
                            result = 0
                        } else if result > 1{
                            result = 1
                        }
                        let newText = "Faigue: \(round((1 - result) * 100)) %"

                        var material = SCNMaterial()
                        if (round((1 - result) * 100)) >= 70 && (round((1 - result) * 100)) < 90 {
                            material.diffuse.contents = UIColor.yellow // 設置文字顏色
                        } else if (round((1 - result) * 100)) >= 90 {
                            material.diffuse.contents = UIColor.red // 設置文字顏色
                        } else {
                            material.diffuse.contents = UIColor.buttom2Color // 設置文字顏色
                        }

                        if (round((1 - result) * 100)) > 70 && self.swAlert.isOn == true {
                            AudioServicesPlaySystemSound(1005)
                        }

                        if (round((1 - result) * 100)) > 70 {
                            Alert.showAlert(title: "警告",
                                            message: "系統檢測到您很想睡覺，建議你進行適度休息",
                                            vc: self,
                                            confirmTitle: "確認")
                        }

                        self.ARText.string = newText
                        self.ARText.materials = [material]
                    }
                    fatigueArray = []
                   count = 0
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - FatigueDetectionBackToStartConcentrateVCDelegate

protocol FatigueDetectionBackToStartConcentrateVCDelegate {
    
    func transformUI()
}

// MARK: - FatigueDetectionBackToMainVCDelegate

protocol FatigueDetectionBackToMainVCDelegate {
    
    func startCatchISO()
}
