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

public struct LogingResponse: Decodable {

    public var accountId: String
    
    public var name: String
    
    public var dor: String
    
    public var friendList: [String]
    
}
