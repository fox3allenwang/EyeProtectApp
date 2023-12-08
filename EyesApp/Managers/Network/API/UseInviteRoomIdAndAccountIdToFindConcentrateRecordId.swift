//
//  UseInviteRoomIdAndAccountIdToFindConcentrateRecordId.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/2.
//

import Foundation

struct UseInviteRoomIdAndAccountIdToFindConcentrateRecordIdRequest: Encodable {
    
    let inviteRoomId: UUID
    
    let accountId: UUID
}
