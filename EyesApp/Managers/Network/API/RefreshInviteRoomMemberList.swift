//
//  RefreshInviteRoomMemberList.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import Foundation

struct RefreshInviteRoomMemberListRequest: Encodable {
    
    let inviteRoomId: UUID
}

struct RefreshInviteRoomMemberListResponse: Decodable {
    
    let memberList: [Member]
    
    struct Member: Decodable {
        
        let accountId: UUID
        
        let name: String
        
        let image: String
    }
}
