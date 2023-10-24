//
//  AddFriendToInviteRoomRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/25.
//

import Foundation

public struct AddFriendToInviteRoomRequest: Encodable {
    public let inviteRoomId: UUID
    public let reciveAccountId: UUID
}
