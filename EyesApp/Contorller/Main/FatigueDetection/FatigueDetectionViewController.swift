//
//  FatigueDetectionViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/6.
//

import UIKit
import ARKit
import AVFoundation
import CoreML

class FatigueDetectionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vARSCN: ARSCNView!
    @IBOutlet weak var lbFatigueDetection: UILabel!
    
    // MARK: - Variables
    
    var result = ""
    var count = 0
    var fatigue = 0
    var noneFatigue = 0
    var fatigueArray: [Float] = []
    
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
        setupARSCNView()
    }
    
    func setupARSCNView() {
        vARSCN.delegate = self
        let config = ARFaceTrackingConfiguration()
        vARSCN.session.run(config)
        
    }
    
    // MARK: - ARJudgeFace
    
    func judgeFace(anchor: ARFaceAnchor) {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let tongueOut = anchor.blendShapes[.tongueOut]
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension

extension FatigueDetectionViewController: ARSCNViewDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let faceMesh = ARSCNFaceGeometry(device: vARSCN.device!)
//        let node = SCNNode(geometry: faceMesh)
//        node.geometry?.firstMaterial?.fillMode = .lines
//        return node
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
//            judgeFace(anchor: faceAnchor as! ARFaceAnchor)
//            print(result)
        }
        
        guard let pixelBuffer = self.vARSCN.session.currentFrame?.capturedImage else { return }
        
        do {
            let modelConfigration = MLModelConfiguration()
            let model = try FatigueDetection_New__Test_76_ACC(configuration: modelConfigration)
            let input = FatigueDetection_New__Test_76_ACCInput(image: pixelBuffer)
            let output = try model.prediction(input: input)
            
           
            fatigueArray.append(Float(output.classLabelProbs.first!.value))
            count += 1
            
            if count == 35 {
                let result = fatigueArray.average
                DispatchQueue.main.async {
                    self.lbFatigueDetection.text = "疲憊指數： \(1 - result) %"
                }
                fatigueArray = []
               count = 0
            }
            
           
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Array where Element: FloatingPoint {
    
    var sum: Element {
        return reduce(0, +)
    }

    var average: Element {
        guard !isEmpty else {
            return 0
        }
        return sum / Element(count)
    }

}

// MARK: - Protocol

