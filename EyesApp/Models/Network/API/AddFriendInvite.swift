//
//  AddFriendInvite.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

struct AddFriendInviteRequest: Encodable {
    
    let accountId: UUID
    
    let name: String
    
    let email: String
}
