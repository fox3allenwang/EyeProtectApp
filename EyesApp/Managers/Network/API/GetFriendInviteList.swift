//
//  GetFriendInviteList.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

struct GetFriendInviteListRequest: Encodable {
    
    let accountId: UUID
}

struct GetFriendInviteListResponse: Decodable {
    
    let friendinviteInfo: [FriendInviteInfo]
    
    struct FriendInviteInfo: Decodable {
        
        let accountId: String
        
        let name: String
        
        let email: String
        
        let image: String
    }
}
