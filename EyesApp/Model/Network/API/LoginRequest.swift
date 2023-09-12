//
//  LoginRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/24.
//

import Foundation

public struct LoginRequest: Codable {
    
    public var email: String
    
    public var password: String
    
    public var deviceToken: String
    
    enum CodingKeys: String, CodingKey {
        
        case email
        
        case password
        
        case deviceToken
    }
    
    public init(email: String,
                password: String,
                deviceToken: String) {
        self.email = email
        self.password = password
        self.deviceToken = deviceToken
    }
}

// 給我一個台灣地名的 enum
//public enum TaiwanCity: String, Codable {
//
//    case taipei = "台北市"
//
//    case newTaipei = "新北市"
//
//    case taoyuan = "桃園市"




//public struct LogingResponse: Decodable {
//
//    public var
//}
