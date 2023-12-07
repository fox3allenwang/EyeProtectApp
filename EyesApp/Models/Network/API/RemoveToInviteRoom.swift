//
//  RemoveToInviteRoom.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/29.
//

import Foundation

struct RemoveToInviteRoomRequest: Encodable {
    
    let inviteRoomId: UUID
    
    let removeAccountId: UUID
}
