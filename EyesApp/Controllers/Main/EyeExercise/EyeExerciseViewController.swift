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
    @IBOutlet weak var rightEyeIcon: UIView!
    @IBOutlet weak var leftEyeIcon: UIView!
    @IBOutlet weak var vIconFace: UIView!
    @IBOutlet weak var vIconLeftEyeWhite: UIView!
    @IBOutlet weak var vIconRightEyeWhite: UIView!
    @IBOutlet weak var vIconLeftEyeClose: UIView!
    @IBOutlet weak var vIconRightEyeClose: UIView!
    @IBOutlet weak var vIconBackground: UIView!
    @IBOutlet weak var lbExerciseGuide: UILabel!
    @IBOutlet weak var imgvSmileLeftEye: UIImageView!
    @IBOutlet weak var imgvSmileRightEye: UIImageView!
    @IBOutlet weak var imgvDazzingHardLeftEye: UIImageView!
    @IBOutlet weak var imgvDazzingHardRightEye: UIImageView!
    
    // MARK: - Variables
    var lookAtTargetEyeLNode: SCNNode = SCNNode()
    var lookAtTargetEyeRNode: SCNNode = SCNNode()
    var virtualPhoneNode: SCNNode = SCNNode()
    var phoneScreenSize: CGSize = CGSize()
    var phoneScreenPointSize = UIScreen.main.bounds.size
    var faceNode: SCNNode?
    var eyeExerciseStepStatus: [Bool] = [false, false, false, false, false]
    
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
    
    var leftEyeSquinting: NSNumber = 0
    var leftEyeSquintingStatus = false
    
    var rightEyeSquinting: NSNumber = 0
    var rightEyeSquintingStatus = false
    
    // 黑色透明遮罩
    var blackBackgroundView = UIView()
    
    // 透明的區塊
    var correctionBoxPath = UIBezierPath()
//    var correctionBoxView = UIView()
    
    var correctionCount: Int = 0
    var stepOneCount = 0
    var stepTwoCount = 0
    var stepThreeCount = 0
    var stepFourCount = 0
    var stepFiveCount = 0
    var stepSixCount = 0
    var stepSevenCount = 0
    var stepEightCount = 0
    
    // 短震動
    let soundShort = SystemSoundID(1519)
    // 短震動
    let soundHeavy = SystemSoundID(1520);
    
    // 校正 Timer
    var correctionTimer = Timer()
    
    var stepOneTimer = Timer()
    var stepTwoTimer = Timer()
    var stepThreeTimer = Timer()
    var stepFourTimer = Timer()
    var stepFiveTimer = Timer()
    var stepSixTimer = Timer()
    var stepSevenTimer = Timer()
    var stepEightTimer = Timer()
    
    var correctionErrorsTimer = Timer()
    
    var correctionMode = true
    
    var completeStatus = false
    
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
        self.title = "Eye Exercise"
        Alert.showToastWith(message: "Step1: 請將手機與眼睛的距離保持在 30~35 cm ", vc: self, during: .long) {
            
            Alert.showToastWith(message: "Step2: 將臉放在中間的臉模中", vc: self, during: .long) {
                Alert.showToastWith(message: "Step3: 將綠色目標框框維持在中間的透明框框等到出現綠色勾勾", vc: self, during: .long) {
                    self.setFaceTrackerView()
                }
            }
        }
        phoneScreenSize = getScreenSize()
        print("\(phoneScreenSize.width), \(phoneScreenSize.height)")
        correctionTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(correctionTimerAction), userInfo: nil, repeats: true)
        eyeDistance.layer.cornerRadius = 20
        eyeDistance.clipsToBounds = true
        setupIconFaceAndEye()
        setupRefreshBarButtonItem()
        lbExerciseGuide.layer.cornerRadius = 20
        lbExerciseGuide.clipsToBounds = true
    }
    
    func setupRefreshBarButtonItem() {
        let refreshBarButtonItem = UIBarButtonItem(title: "重整", style: .plain, target: self, action: #selector(refreshBarButtonItemAction))
        navigationItem.rightBarButtonItem = refreshBarButtonItem
    }
    
    func setupIconFaceAndEye() {
        vIconBackground.layer.cornerRadius = 20
        
        vIconFace.backgroundColor = .clear
        vIconFace.layer.cornerRadius = 20
        vIconFace.layer.borderColor = UIColor.buttom2Color?.cgColor
        vIconFace.layer.borderWidth = 4
        
        vIconLeftEyeWhite.layer.cornerRadius = 23
        vIconLeftEyeWhite.backgroundColor = UIColor.clear
        vIconLeftEyeWhite.layer.borderWidth = 4
        vIconLeftEyeWhite.layer.borderColor = UIColor.buttom2Color?.cgColor
        vIconRightEyeWhite.layer.cornerRadius = 23
        vIconRightEyeWhite.backgroundColor = UIColor.clear
        vIconRightEyeWhite.layer.borderColor = UIColor.buttom2Color?.cgColor
        vIconRightEyeWhite.layer.borderWidth = 4
        
        rightEyeIcon.layer.cornerRadius = 12
        leftEyeIcon.layer.cornerRadius = 12
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
        faceTrackerView.showsStatistics = false
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
            
            // 設定小人動畫
            self.leftEyeIcon.transform = CGAffineTransform(translationX: (eyeLLookAt.x / 100) + 8,
                                                           y:  -(eyeLLookAt.y / 100) + 8)
            self.rightEyeIcon.transform = CGAffineTransform(translationX: (eyeRLookAt.x / 100) + 14,
                                                            y: -(eyeRLookAt.y / 100) + 8)
            
            // 校正模式完成與否要做的事
            if self.correctionMode == false {
                self.eyePositionIndicatorView.isHidden = true
            } else {
                self.eyePositionIndicatorView.isHidden = false
                self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: smoothEyeLookAtPositionX,
                                                                            y: smoothEyeLookAtPositionY)
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
            
            
            // 最好維持在 30~35 cm 之間
            self.eyeDistance.text = "\(self.distance)cm"
            
        }
    }
    
    func setupAnimate(complete: (() -> Void)? = nil) {
        let animationView = LottieAnimationView(name: "Check")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.4)
        animationView.loopMode = .repeatBackwards(1)
        animationView.animationSpeed = 1.2
        vAnimate.addSubview(animationView)
        animationView.play { animate in
            complete?()
        }
    }
    
    func completeStep() {
        // 使用動畫延遲 1 秒的方式，切換到下一個步驟
        completeStatus = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            // 在动画块中，将视图的透明度设置为 1.0（完全可见）
            DispatchQueue.main.async {
                self.vIconLeftEyeWhite.isHidden = true
                self.vIconRightEyeWhite.isHidden = true
                self.vIconRightEyeClose.isHidden = true
                self.vIconLeftEyeClose.isHidden = true
                self.imgvDazzingHardLeftEye.isHidden = true
                self.imgvDazzingHardRightEye.isHidden = true
                self.imgvSmileLeftEye.isHidden = false
                self.imgvSmileRightEye.isHidden = false
            }
        }, completion: { _ in
            // 在動畫結束後執行
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.vIconLeftEyeWhite.isHidden = false
                    self.vIconRightEyeWhite.isHidden = false
                    self.imgvSmileLeftEye.isHidden = true
                    self.imgvSmileRightEye.isHidden = true
                })
                self.completeStatus = false
            }
        })
        
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
        
        if correctionCount == 5 {
            correctionTimer.invalidate()
            AudioServicesPlaySystemSound(1000)
            UIView.transition(with: self.vfaceFram, duration: 3, options: .transitionCrossDissolve) {
                self.vfaceFram.isHidden = true
            }
            self.completeStep()
            setupAnimate {
                self.correctionMode = false
                self.eyePositionIndicatorView.isHidden = true
                self.blackBackgroundView.isHidden = true
                Alert.showAlert(title: "校正完成", message: "請與眼睛保持一樣角度以及距離來進行後續的眼睛保健操", vc: self, confirmTitle: "確認") {
                    self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(2 - self.stepOneCount) 秒"
                    self.lbExerciseGuide.isHidden = false
                    self.stepOneTimer = Timer.scheduledTimer(timeInterval: 1,
                                                                target: self,
                                                                selector: #selector(self.exerciseStep1),
                                                                userInfo: nil,
                                                                repeats: true)
                }
            }
        }
    }
    
    @objc func exerciseStep1() {
        if leftEyeSquintingStatus == true &&
            rightEyeSquintingStatus == true &&
            distance <= 35 &&
            distance >= 30 {
            AudioServicesPlaySystemSound(soundShort)
            stepOneCount += 1
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(2 - stepOneCount) 秒"
        } else {
            stepOneCount = 0
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(2 - stepOneCount) 秒"
        }
        if stepOneCount == 2 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepOneTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepTwoTimer = Timer.scheduledTimer(timeInterval: 1,
                                                            target: self,
                                                            selector: #selector(self.exerciseStep2),
                                                            userInfo: nil,
                                                            repeats: true)
            }
        }
    }
    
    @objc func exerciseStep2() {
        if showLookAtPointX >= ((UIScreen.main.bounds.width / 1.13) - 500) &&
            showLookAtPointX <= ((UIScreen.main.bounds.width / 1.13) + 500) &&
            showLookAtPointY <= -500 &&
            distance <= 35 &&
            distance >= 30  {
            AudioServicesPlaySystemSound(soundShort)
            stepTwoCount += 1
            self.lbExerciseGuide.text = "請往上看並維持 \(3 - stepTwoCount) 秒"
        } else {
            stepTwoCount = 0
            self.lbExerciseGuide.text = "請往上看並維持 \(3 - stepTwoCount) 秒"
        }
        if stepTwoCount == 3 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepTwoTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepThreeTimer = Timer.scheduledTimer(timeInterval: 1,
                                                            target: self,
                                                            selector: #selector(self.exerciseStep3),
                                                            userInfo: nil,
                                                            repeats: true)
            }
        }
    }
    
    @objc func exerciseStep3() {
        if leftEyeSquintingStatus == true &&
            rightEyeSquintingStatus == true &&
            distance <= 35 &&
            distance >= 30 {
            AudioServicesPlaySystemSound(soundShort)
            stepThreeCount += 1
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(3 - stepThreeCount) 秒"
        } else {
            stepThreeCount = 0
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(3 - stepThreeCount) 秒"
        }
        if stepThreeCount == 3 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepThreeTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepFourTimer = Timer.scheduledTimer(timeInterval: 1,
                                                            target: self,
                                                            selector: #selector(self.exerciseStep4),
                                                            userInfo: nil,
                                                            repeats: true)
            }
        }
    }
    
    @objc func exerciseStep4() {
        if showLookAtPointY >= ((UIScreen.main.bounds.height / 1.22) - 500) &&
            showLookAtPointY <= ((UIScreen.main.bounds.height / 1.22) + 500) &&
            showLookAtPointX <= -400 &&
            distance <= 35 &&
            distance >= 30  {
            AudioServicesPlaySystemSound(soundShort)
            stepFourCount += 1
            self.lbExerciseGuide.text = "請往左看並維持 \(5 - stepFourCount) 秒"
        } else {
            stepFourCount = 0
            self.lbExerciseGuide.text = "請往左看並維持 \(5 - stepFourCount) 秒"
        }
        if stepFourCount == 5 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepFourTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepFiveTimer = Timer.scheduledTimer(timeInterval: 1,
                                                          target: self,
                                                          selector: #selector(self.exerciseStep5),
                                                          userInfo: nil,
                                                          repeats: true)
            }
        }
    }
    
    @objc func exerciseStep5() {
        if leftEyeSquintingStatus == true &&
            rightEyeSquintingStatus == true &&
            distance <= 35 &&
            distance >= 30 {
            AudioServicesPlaySystemSound(soundShort)
            stepFiveCount += 1
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(3 - stepFiveCount) 秒"
        } else {
            stepFiveCount = 0
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(3 - stepFiveCount) 秒"
        }
        if stepFiveCount == 3 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepFiveTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepSixTimer = Timer.scheduledTimer(timeInterval: 1,
                                                         target: self,
                                                         selector: #selector(self.exerciseStep6),
                                                         userInfo: nil,
                                                         repeats: true)
            }
        }
    }
    
    @objc func exerciseStep6() {
        if showLookAtPointX >= ((UIScreen.main.bounds.width / 1.13) - 500) &&
            showLookAtPointX <= ((UIScreen.main.bounds.width / 1.13) + 500) &&
            showLookAtPointY >= 1400 &&
            distance <= 35 &&
            distance >= 30 {
            AudioServicesPlaySystemSound(soundShort)
            stepSixCount += 1
            self.lbExerciseGuide.text = "請往下看並維持 \(5 - stepSixCount) 秒"
        } else {
            stepSixCount = 0
            self.lbExerciseGuide.text = "請往下看並維持 \(5 - stepSixCount) 秒"
        }
        if stepSixCount == 5 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepSixTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepSevenTimer = Timer.scheduledTimer(timeInterval: 1,
                                                           target: self,
                                                           selector: #selector(self.exerciseStep7),
                                                           userInfo: nil,
                                                           repeats: true)
            }
        }
    }
    
    @objc func exerciseStep7() {
        if leftEyeSquintingStatus == true &&
            rightEyeSquintingStatus == true &&
            distance <= 35 &&
            distance >= 30 {
            AudioServicesPlaySystemSound(soundShort)
            stepSevenCount += 1
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(3 - stepSevenCount) 秒"
        } else {
            stepSevenCount = 0
            self.lbExerciseGuide.text = "請緊閉雙眼並維持 \(3 - stepSevenCount) 秒"
        }
        if stepSevenCount == 3 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepSevenTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.stepEightTimer = Timer.scheduledTimer(timeInterval: 1,
                                                           target: self,
                                                           selector: #selector(self.exerciseStep8),
                                                           userInfo: nil,
                                                           repeats: true)
            }
        }
    }
    
    @objc func exerciseStep8() {
        if showLookAtPointY >= ((UIScreen.main.bounds.height / 1.22) - 500) &&
            showLookAtPointY <= ((UIScreen.main.bounds.height / 1.22) + 500) &&
            showLookAtPointX >= 1200 &&
            distance <= 35 &&
            distance >= 30  {
            AudioServicesPlaySystemSound(soundShort)
            stepEightCount += 1
            self.lbExerciseGuide.text = "請往右看並維持 \(5 - stepEightCount) 秒"
        } else {
            stepEightCount = 0
            self.lbExerciseGuide.text = "請往右看並維持 \(5 - stepEightCount) 秒"
        }
        if stepEightCount == 5 {
            AudioServicesPlaySystemSound(soundHeavy)
            AudioServicesPlaySystemSound(1000)
            stepEightTimer.invalidate()
            self.completeStep()
            setupAnimate {
                self.lbExerciseGuide.text = "護眼操已完成"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let now = dateFormatter.string(from: Date())
                self.callAPIAddMissionComplete(missionId: UserPreferences.shared.eyeExerciseMissionId, accountId: UserPreferences.shared.accountId, date: now)
                
            }
        }
    }
    
    @objc func refreshBarButtonItemAction() {
        faceTrackerView.session.pause()
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        faceTrackerView.automaticallyUpdatesLighting = true
        faceTrackerView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - callAPIAddMissionComplete
    
    func callAPIAddMissionComplete(missionId: String,
                                   accountId: String,
                                   date: String) {
        let request = AddMissionCompleteRequest(missionId: UUID(uuidString: missionId)!,
                                                accountId: UUID(uuidString: accountId)!,
                                                date: date)
        
        Task {
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
        
        // 新增眼睛周圍收縮判斷
        leftEyeSquinting = faceAnchor.blendShapes[.eyeSquintLeft]!
        rightEyeSquinting = faceAnchor.blendShapes[.eyeSquintRight]!
        
        
        // 計算扎眼機率，如果皆大於 50% 則隱藏專注點
        if leftEyeDazzing.decimalValue >= 0.5 && rightEyeDazzing.decimalValue >= 0.5 ||
            correctionMode == false {
            DispatchQueue.main.async {
                self.eyePositionIndicatorView.isHidden = true
            }
        } else {
            DispatchQueue.main.async {
                self.eyePositionIndicatorView.isHidden = false
            }
        }
        
        if rightEyeDazzing.decimalValue >= 0.7 && completeStatus == false {
            if rightEyeSquinting.decimalValue >= 0.2 {
                DispatchQueue.main.async {
                    self.imgvDazzingHardLeftEye.isHidden = false
                    self.vIconLeftEyeWhite.isHidden = true
                    self.vIconLeftEyeClose.isHidden = true
                    self.rightEyeSquintingStatus = true
                }
            } else {
                DispatchQueue.main.async {
                    self.vIconLeftEyeClose.isHidden = false
                    self.vIconLeftEyeWhite.isHidden = true
                    self.imgvDazzingHardLeftEye.isHidden = true
                    self.rightEyeSquintingStatus = false
                }
            }
        } else if completeStatus == false {
            DispatchQueue.main.async {
                self.vIconLeftEyeClose.isHidden = true
                self.vIconLeftEyeWhite.isHidden = false
                self.imgvDazzingHardLeftEye.isHidden = true
                self.rightEyeSquintingStatus = false
            }
        }
        
        if leftEyeDazzing.decimalValue >= 0.7  && completeStatus == false {
            if leftEyeSquinting.decimalValue >= 0.2 {
                DispatchQueue.main.async {
                    self.imgvDazzingHardRightEye.isHidden = false
                    self.vIconRightEyeWhite.isHidden = true
                    self.vIconRightEyeClose.isHidden = true
                    self.leftEyeSquintingStatus = true
                }
            } else {
                DispatchQueue.main.async {
                    self.vIconRightEyeClose.isHidden = false
                    self.vIconRightEyeWhite.isHidden = true
                    self.imgvDazzingHardRightEye.isHidden = true
                    self.leftEyeSquintingStatus = false
                }
            }
        } else if completeStatus == false {
            DispatchQueue.main.async {
                self.vIconRightEyeClose.isHidden = true
                self.vIconRightEyeWhite.isHidden = false
                self.imgvDazzingHardRightEye.isHidden = true
                self.leftEyeSquintingStatus = false
            }
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
