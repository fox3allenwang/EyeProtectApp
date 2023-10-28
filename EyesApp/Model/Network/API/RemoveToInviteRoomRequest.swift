//
//  RemoveToInviteRoomRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/29.
//

import Foundation

public struct RemoveToInviteRoomRequest: Encodable {
    public let inviteRoomId: UUID
    public let removeAccountId: UUID
}
