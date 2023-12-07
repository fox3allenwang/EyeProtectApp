//
//  Register.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import Foundation

struct RegisterRequest: Codable {
    
    let dor: String
    
    let email: String
    
    let password: String
    
    let name: String
    
    let image: String
}
