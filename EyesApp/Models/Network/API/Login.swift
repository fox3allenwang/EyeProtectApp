//
//  Login.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/24.
//

import Foundation

struct LoginRequest: Codable {
    
    let email: String
    
    let password: String
    
    let deviceToken: String
}

struct LogingResponse: Decodable {
    
    let accountId: String
    
    let name: String
    
    let dor: String
    
    let friendList: [String]
}
