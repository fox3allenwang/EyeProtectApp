//
//  FindAccount.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/31.
//

import Foundation

struct FindAccountRequest: Encodable {
    
    let accountId: UUID
}

struct FindAccountResponse: Decodable {
    
    let accountId: UUID
    
    let name: String
    
    let image: String
}
