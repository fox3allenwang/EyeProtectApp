//
//  GetFriendList.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/1.
//

import Foundation

struct GetFriendListRequest: Codable {
    
    let accountId: UUID
}

struct GetFriendListResponse: Decodable {
    
    let result: Int
    
    let data: [FriendInfo]
    
    let message: String
    
    struct FriendInfo: Decodable {
        
        let accountId: String
        
        let email: String
        
        let name: String
        
        let image: String
    }
}
