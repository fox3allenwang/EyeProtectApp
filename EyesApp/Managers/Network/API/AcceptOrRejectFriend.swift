//
//  AcceptOrRejectFriend.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

struct AcceptOrRejectFriendRequest: Encodable {
    
    let reciveAccountId: UUID
    
    let sendAccountId: UUID
}
