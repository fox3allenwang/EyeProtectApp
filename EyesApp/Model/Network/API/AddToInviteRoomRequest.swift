//
//  AddToInviteRoomRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import Foundation

public struct AddToInviteRoomRequest: Encodable {
    public let inviteRoomId: UUID
    public let reciveAccountId: UUID
}
