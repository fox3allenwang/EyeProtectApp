//
//  AppDefine.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/8/19.
//

import CoreBluetooth
import Foundation

struct AppDefine {
    
    static var userName = ""
    
    static var userAccount = ""
    
    static var userPassword = ""
    
    static var friendList: [String] = []
    
    static var news: [News] = []
}

struct News {
    
    let newsTitle: String
    
    let newsMessage: String
}

struct Bluelight {
    
    static var peripheral: CBPeripheral?
    
    static var characteristic: CBCharacteristic?
}

struct Lamp {
    
    static var peripheral: CBPeripheral?
    
    static var characteristic: CBCharacteristic?
}
