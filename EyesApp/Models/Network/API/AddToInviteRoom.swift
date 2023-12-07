//
//  AddToInviteRoom.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import Foundation

struct AddToInviteRoomRequest: Encodable {
    
    let inviteRoomId: UUID
    
    let reciveAccountId: UUID
}
