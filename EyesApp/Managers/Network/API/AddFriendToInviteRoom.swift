//
//  AddFriendToInviteRoom.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/25.
//

import Foundation

struct AddFriendToInviteRoomRequest: Encodable {
    
    let inviteRoomId: UUID
    
    let reciveAccountId: UUID
}
