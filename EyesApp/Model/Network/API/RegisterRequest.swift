//
//  RegisterRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import Foundation

public struct RegisterRequest: Codable {
    
    public var dor: String
    
    public var email: String
    
    public var password: String
    
    public var name: String
    
    public var image: String
    
    enum CodingKeys: String, CodingKey {
        
        case dor
        
        case email
        
        case password
        
        case name
        
        case image
    }
    
    public init(dor: String,
                email: String,
                password: String,
                name: String,
                image: String) {
        self.dor = dor
        self.email = email
        self.password = password
        self.name = name
        self.image = image
    }
}
