//
//  AuthenticationResponse.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/18.
//

import Foundation

public struct AuthenticationResponse<T: Decodable>: Decodable {
    
    public let result: Int
    
    public var data: T?
    
    public let message: String
    
    public let token: String
}
