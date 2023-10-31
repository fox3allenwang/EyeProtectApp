//
//  AppDefine.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/8/19.
//

import Foundation
import CoreBluetooth

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
    var peripheral: CBPeripheral
    var characteristic: CBCharacteristic
}

struct Lamp {
    var peripheral: CBPeripheral
    var characteristic: CBCharacteristic
}
