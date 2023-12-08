//
//  AuthenticationResponse.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/18.
//

import Foundation

struct AuthenticationResponse<T: Decodable>: Decodable {
    
    let result: Int
    
    let data: T
    
    let message: String
    
    let token: String
}
