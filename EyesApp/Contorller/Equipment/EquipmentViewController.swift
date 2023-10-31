//
//  EquipmentViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit

class EquipmentViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lightView: UIView!
    @IBOutlet weak var blueDetectionView: UIView!
    @IBOutlet weak var ivgLight: UIImageView!
    @IBOutlet weak var ivgBlueDetection: UIView!
    @IBOutlet weak var lightSlider: UISlider!
    @IBOutlet weak var lbBlueLightValue: UILabel!
    
    // MARK: - Variables
    var changeBackgroundValue :CGFloat?
    var changeImageValueR :CGFloat?
    var changeImageValueG :CGFloat?
    var changeImageValueB :CGFloat?
    
    let bluetooth = BluetoothServices.shared
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("EquipmentViewController")
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
        setupImageView()
        setupEquipmentView()
    }
    
    func setupImageView() {
        if #available(iOS 16.0, *) {
            ivgLight.image = UIImage(systemName: "lamp.desk")
        } else {
            ivgLight.image = UIImage(systemName: "lightbulb")
        }
    }
    
    func setupEquipmentView() {
        lightView.layer.cornerRadius = 20
        lightView.layer.shadowOffset = CGSize(width: 5, height: 5)
        lightView.layer.shadowOpacity = 0.1
        lightView.layer.shadowRadius = 20
        
        blueDetectionView.layer.cornerRadius = 20
        blueDetectionView.layer.shadowOffset = CGSize(width: 5, height: 5)
        blueDetectionView.layer.shadowOpacity = 0.1
        blueDetectionView.layer.shadowRadius = 20
    }
    
    func changeColor() {
        changeBackgroundValue = CGFloat(lightSlider.value / 100) * 0.5
        changeImageValueR = 0.23137 / CGFloat(lightSlider.value / 100)
        changeImageValueG = 0.49411 / CGFloat(lightSlider.value / 100)
        changeImageValueB = 0.203921 / CGFloat(lightSlider.value / 100)
    }
    
    // MARK: - IBAction
    
    // 電燈開關放這裡
    @IBAction func clickbtnLight() {
        bluetooth.connectPeripheral(peripheral: Lamp.peripheral!)
        
        let data = "0".data(using: .utf8)
        bluetooth.writeValue(type: .withoutResponse, data: data!)
    }
    
    // 調亮度放這裡
    @IBAction func slideLight() {
        print(lightSlider.value)
        changeColor()
        lightView.backgroundColor = UIColor(hue: 0.35, saturation: 0.75, brightness: 0.49 + CGFloat(changeBackgroundValue!), alpha: 1)
        ivgLight.tintColor = UIColor(red: changeImageValueR!,
                                     green: changeImageValueG!,
                                     blue: changeImageValueB!, alpha: 1)
        let step: Float = 20
        lightSlider.value = (lightSlider.value / step).rounded() * step
    }
    
    @IBAction func clickLightBtn() {
        bluetooth.connectPeripheral(peripheral: Lamp.peripheral!)
        
        if #available(iOS 16.0, *) {
            if lightSlider.isHidden == false {
                let data = "F".data(using: .utf8)
                bluetooth.writeValue(type: .withoutResponse, data: data!)
                
                lightSlider.isHidden = true
                ivgLight.image = UIImage(systemName: "lamp.desk")
                lightView.backgroundColor = UIColor.buttomColor
                ivgLight.tintColor = .white
            } else {
                let data = "O".data(using: .utf8)
                bluetooth.writeValue(type: .withoutResponse, data: data!)
                
                lightSlider.isHidden = false
                ivgLight.image = UIImage(systemName: "lamp.desk.fill")
            }
        } else {
            if lightSlider.isHidden == false {
                let data = "F".data(using: .utf8)
                bluetooth.writeValue(type: .withoutResponse, data: data!)
                
                lightSlider.isHidden = true
                ivgLight.image = UIImage(systemName: "lightbulb")
                lightView.backgroundColor = UIColor.buttomColor
                ivgLight.tintColor = .white
            } else {
                let data = "O".data(using: .utf8)
                bluetooth.writeValue(type: .withoutResponse, data: data!)
                
                lightSlider.isHidden = false
                ivgLight.image = UIImage(systemName: "lightbulb.fill")
            }
        }
    }
    
}

// MARK: - Extension

// MARK: - Protocol
