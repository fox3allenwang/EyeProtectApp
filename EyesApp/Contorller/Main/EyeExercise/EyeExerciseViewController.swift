//
//  EyeExerciseViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/29.
//

import UIKit
import ARKit
import SceneKit

class EyeExerciseViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var faceTrackerView: ARSCNView!
    @IBOutlet weak var eyePositionIndicatorView: UIView!
    @IBOutlet weak var eyeDistance: UILabel!
    
    // MARK: - Variables
    var lookAtTargetEyeLNode: SCNNode = SCNNode()
    var lookAtTargetEyeRNode: SCNNode = SCNNode()
    var virtualPhoneNode: SCNNode = SCNNode()
    var phoneScreenSize: CGSize = CGSize()
    var phoneScreenPointSize = UIScreen.main.bounds.size
    var faceNode: SCNNode?
    
    var eyeLNode: SCNNode = SCNNode()
    
    var eyeRNode: SCNNode = SCNNode()
    
    var virtualScreenNode: SCNNode = {
        
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        
        return SCNNode(geometry: screenGeometry)
    }()
    
    var eyeLookAtPositionXs: [CGFloat] = []
    
    var eyeLookAtPositionYs: [CGFloat] = []
    
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
        faceTrackerView.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setFaceTrackerView()
        phoneScreenSize = getScreenSize()
        print("\(phoneScreenSize.width), \(phoneScreenSize.height)")
    }
    
    func setFaceTrackerView() {
        faceTrackerView.delegate = self
        faceTrackerView.showsStatistics = true
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        faceTrackerView.automaticallyUpdatesLighting = true
        faceTrackerView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
    
        lookAtTargetEyeLNode.position.z = 2
        lookAtTargetEyeRNode.position.z = 2
        
        eyePositionIndicatorView.alpha = 0.4
        eyePositionIndicatorView.layer.cornerRadius = 20
    }
    
    func getScreenSize() -> CGSize {
        // 將物理尺寸轉換成 mm (以下以 iPhone X 的尺寸為準)
        let meterWidth: CGFloat = 0.0623908297
        let meterHeight: CGFloat = 0.135096943231532

        // 計算點和像素的比例
        let pointPerMeterWidth = 375.0 / meterWidth
        let pointPerMeterHeight = 812.0 / meterHeight

        // 根據比例計算所有的設備螢幕尺寸
        let unitWidth = UIScreen.main.bounds.size.width / pointPerMeterWidth
        let unitHeight =  UIScreen.main.bounds.size.height / pointPerMeterHeight
       return CGSize(width: unitWidth, height: unitHeight)
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        eyeRNode.simdTransform = anchor.rightEyeTransform
        eyeLNode.simdTransform = anchor.leftEyeTransform
        
        var eyeLLookAt = CGPoint()
        var eyeRLookAt = CGPoint()
        
        let heightCompensation: CGFloat = -50
        let widthCompensation: CGFloat = 0
        
        DispatchQueue.main.async {
            
            let phoneScreenEyeRHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.eyeRNode.worldPosition, to: self.lookAtTargetEyeRNode.worldPosition, options: nil)
            
            let phoneScreenEyeLHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.eyeLNode.worldPosition, to: self.lookAtTargetEyeLNode.worldPosition, options: nil)
            
            for result in phoneScreenEyeRHitTestResults {
                
                eyeRLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width - widthCompensation
                
                eyeRLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            for result in phoneScreenEyeLHitTestResults {
                
                eyeLLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeLLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            let smoothThresholdNumber: Int = 10
            self.eyeLookAtPositionXs.append((eyeRLookAt.x + eyeLLookAt.x) / 2)
            self.eyeLookAtPositionYs.append(-(eyeRLookAt.y + eyeLLookAt.y) / 2)
            self.eyeLookAtPositionXs = Array(self.eyeLookAtPositionXs.suffix(smoothThresholdNumber))
            self.eyeLookAtPositionYs = Array(self.eyeLookAtPositionYs.suffix(smoothThresholdNumber))
            
            let smoothEyeLookAtPositionX = self.eyeLookAtPositionXs.average!
            let smoothEyeLookAtPositionY = self.eyeLookAtPositionYs.average!
            
            self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: smoothEyeLookAtPositionX, y: smoothEyeLookAtPositionY)
            
            
            var lookAtPositionXLabel = "\(Int(round(smoothEyeLookAtPositionX + self.phoneScreenPointSize.width / 2)))"
           
            var lookAtPositionYLabel = "\(Int(round(smoothEyeLookAtPositionY + self.phoneScreenPointSize.height / 2)))"
            print("x: \(lookAtPositionXLabel), y: \(lookAtPositionYLabel)")
            // Calculate distance of the eyes to the camera
            let distanceL = self.eyeLNode.worldPosition - SCNVector3Zero
            let distanceR = self.eyeRNode.worldPosition - SCNVector3Zero
            
            // Average distance from two eyes
            let distance = (distanceL.length() + distanceR.length()) / 2
            
            // 最維持在 45 cm
            self.eyeDistance.text = "\(Int(round(distance * 100)))"
            
        }
    }

    
    
    // MARK: - IBAction
    
}

// MARK: - ARSCN Extension

extension EyeExerciseViewController: ARSCNViewDelegate, ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        let faceMesh = ARSCNFaceGeometry(device: faceTrackerView.device!)
        faceNode = SCNNode(geometry: faceMesh)
        faceNode!.geometry?.firstMaterial?.fillMode = .lines
        faceNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.white

        faceTrackerView.scene.rootNode.addChildNode(faceNode!)
        faceTrackerView.scene.rootNode.addChildNode(virtualPhoneNode)
        virtualPhoneNode.addChildNode(virtualScreenNode)

        faceNode!.addChildNode(eyeLNode)
        faceNode!.addChildNode(eyeRNode)
        eyeLNode.addChildNode(lookAtTargetEyeLNode)
        eyeRNode.addChildNode(lookAtTargetEyeRNode)

        return faceNode!
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry =  node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
        }
        faceNode!.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        virtualPhoneNode.transform = (faceTrackerView.pointOfView?.transform)!
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        faceNode!.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        update(withFaceAnchor: faceAnchor)
    }
}

// MARK: - Protocol
