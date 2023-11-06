//
//  EyeExerciseViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/29.
//

import UIKit
import ARKit
import SceneKit
import Lottie

class EyeExerciseViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var faceTrackerView: ARSCNView!
    @IBOutlet weak var eyePositionIndicatorView: UIView!
    @IBOutlet weak var eyeDistance: UILabel!
    @IBOutlet weak var vAnimate: UIView!
    @IBOutlet weak var vfaceFram: UIView!
    
    // MARK: - Variables
    var lookAtTargetEyeLNode: SCNNode = SCNNode()
    var lookAtTargetEyeRNode: SCNNode = SCNNode()
    var virtualPhoneNode: SCNNode = SCNNode()
    var phoneScreenSize: CGSize = CGSize()
    var phoneScreenPointSize = UIScreen.main.bounds.size
    var faceNode: SCNNode?
    
    var eyeLNode: SCNNode = SCNNode()
    
//    var eyeLNode: SCNNode = {
//        let guessTry = SCNCone(topRadius: 0.003, bottomRadius: 1, height: 0.1)
//        guessTry.radialSegmentCount = 3
//        guessTry.firstMaterial?.diffuse.contents = UIColor.blue
//        let node = SCNNode()
//        node.geometry = guessTry
//        node.eulerAngles.x = -.pi
//
//
//        let parentNode = SCNNode()
//        parentNode.addChildNode(node)
//        return parentNode
//
//    }()
    
    var eyeRNode: SCNNode = SCNNode()
    
    var virtualScreenNode: SCNNode = {
        
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        
        return SCNNode(geometry: screenGeometry)
    }()
    
    var eyeLookAtPositionXs: [CGFloat] = []
    
    var eyeLookAtPositionYs: [CGFloat] = []
    
    var lookAtPointX:CGFloat = 0.0
    var lookAtPointy:CGFloat = 0.0
    
    var showLookAtPointX: CGFloat = 0.0
    var showLookAtPointY: CGFloat = 0.0
    
    var distance = 0
    
    var leftEyeDazzing: NSNumber = 0
    
    var rightEyeDazzing:NSNumber = 0
    
    // 黑色透明遮罩
    var blackBackgroundView = UIView()
    
    // 透明的區塊
    var correctionBoxPath = UIBezierPath()
//    var correctionBoxView = UIView()
    
    var correctionCount: Int = 0
    
    // 短震動
    let soundShort = SystemSoundID(1519)
    
    // 校正 Timer
    var correctionTimer = Timer()
    
    var correctionErrorsTimer = Timer()
    
    var correctionMode = true
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        correctionRectOfInterest()
        correctionBlackView()
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
        correctionTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(correctionTimerAction), userInfo: nil, repeats: true)
        eyeDistance.layer.cornerRadius = 20
        eyeDistance.clipsToBounds = true
    }
    
    func correctionRectOfInterest() {
        let width = eyePositionIndicatorView.frame.width * 1.3
        let newX = view.frame.width / 2 - (width / 2)
        let newY = view.frame.height / 2 - (width / 0.8)
        let tempPath = UIBezierPath(roundedRect: CGRect(x: newX, y: newY, width: width, height: width),
                                    cornerRadius: width / 10)
        correctionBoxPath = tempPath
    }
    
    func correctionBlackView() {
        blackBackgroundView = UIView(frame: UIScreen.main.bounds)
        blackBackgroundView.backgroundColor = UIColor.black
        blackBackgroundView.alpha = 0.6
        blackBackgroundView.layer.mask = addTransparencyView(tempPath: correctionBoxPath) // 只有遮罩層覆蓋的地方才會顯示出來
        blackBackgroundView.layer.name = "blackBackgroundView"
        faceTrackerView!.addSubview(blackBackgroundView)
    }
    
    func addTransparencyView(tempPath: UIBezierPath) -> CAShapeLayer {
        let path = UIBezierPath(rect: UIScreen.main.bounds)
        path.append(tempPath)
        path.usesEvenOddFillRule = true
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor // 其他顏色都可以，只要不是透明的
        shapeLayer.fillRule = .evenOdd
        
        return shapeLayer
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
        
        var heightCompensation: CGFloat = 0.0
        var widthCompensation: CGFloat = 0.0
        heightCompensation = -200
        widthCompensation = -100
        
//        if UIScreen.main.bounds.width >= 428.0 {
//            // iphone 12
//            heightCompensation = -250
//            widthCompensation = -300
//        } else {
//            // iphone 14
//            heightCompensation = -100
//            widthCompensation = -200
//        }
        
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
            
            if self.correctionMode == false {
                self.eyePositionIndicatorView.isHidden = true
            } else {
                self.eyePositionIndicatorView.isHidden = false
                self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: smoothEyeLookAtPositionX, y: smoothEyeLookAtPositionY)
            }
            
            
            
            var lookAtPositionXLabel = "\(Int(round(smoothEyeLookAtPositionX + self.phoneScreenPointSize.width / 2)))"
           
            var lookAtPositionYLabel = "\(Int(round(smoothEyeLookAtPositionY + self.phoneScreenPointSize.height / 2)))"
            print("x: \(lookAtPositionXLabel), y: \(lookAtPositionYLabel)")
            self.lookAtPointX = smoothEyeLookAtPositionX
            self.lookAtPointy = smoothEyeLookAtPositionY
            
            self.showLookAtPointY = smoothEyeLookAtPositionY + self.phoneScreenPointSize.height / 2
            self.showLookAtPointX = smoothEyeLookAtPositionX + self.phoneScreenPointSize.width / 2
            
            // Calculate distance of the eyes to the camera
            let distanceL = self.eyeLNode.worldPosition - SCNVector3Zero
            let distanceR = self.eyeRNode.worldPosition - SCNVector3Zero
            
            // Average distance from two eyes
            self.distance = Int(round(((distanceL.length() + distanceR.length()) / 2) * 100))
            
            
            // 最維持在 45 cm
            self.eyeDistance.text = "\(self.distance)"
            
        }
    }
    
    func setupAnimate(complete: (() -> Void)?) {
        let animationView = LottieAnimationView(name: "Check")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.4)
        animationView.loopMode = .repeatBackwards(1)
        animationView.animationSpeed = 1.2
        vAnimate.addSubview(animationView)
        animationView.play { animate in
            complete!()
        }
    }
    
    // MARK: - IBAction
    @objc func correctionTimerAction() {
        if showLookAtPointX >= ((UIScreen.main.bounds.width / 1.13) - 50) &&
            showLookAtPointX <= ((UIScreen.main.bounds.width / 1.13) + 50) &&
            showLookAtPointY >= (UIScreen.main.bounds.height / 1.22) - 50 &&
            showLookAtPointY <= (UIScreen.main.bounds.height / 1.22) + 50 &&
            distance <= 35 &&
            distance >= 30
        {
            AudioServicesPlaySystemSound(soundShort)
            correctionCount += 1
        } else {
            correctionCount = 0
        }
        
        if correctionCount == 10 {
            correctionTimer.invalidate()
            setupAnimate {
                self.correctionMode = false
                self.eyePositionIndicatorView.isHidden = true
                self.blackBackgroundView.isHidden = true
                self.eyePositionIndicatorView.isHidden = true
                Alert.showAlert(title: "校正完成", message: "請與眼睛保持一樣角度以及距離來進行後續的眼睛保健操", vc: self, confirmTitle: "確認")
                UIView.transition(with: self.vfaceFram, duration: 0.5, options: .transitionCrossDissolve) {
                    self.vfaceFram.isHidden = true
                }
            }
        }
    }
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
//            faceGeometry.firstMaterial?.diffuse.contents = UIColor.themeColor
            faceGeometry.update(from: faceAnchor.geometry)
            if correctionMode == false {
                faceGeometry.firstMaterial?.diffuse.contents = UIColor.clear
            }
        }
        faceNode!.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        // 新增扎眼判斷
        leftEyeDazzing = faceAnchor.blendShapes[.eyeBlinkLeft]!
        rightEyeDazzing = faceAnchor.blendShapes[.eyeBlinkRight]!
        
        // 計算扎眼機率，如果皆大於 50% 則隱藏專注點
        if leftEyeDazzing.decimalValue >= 0.5 && rightEyeDazzing.decimalValue >= 0.5 ||
            correctionMode == false {
            eyePositionIndicatorView.isHidden = true
        } else {
            eyePositionIndicatorView.isHidden = false
        }
        
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
