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
    
    
    enum CodingKeys: String, CodingKey {
        
        case email
        
        case password
    }
    
    public init(email: String,
                password: String) {
        self.email = email
        self.password = password
    }
}
