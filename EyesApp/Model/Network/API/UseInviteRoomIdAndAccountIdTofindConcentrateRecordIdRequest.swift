//
//  UseInviteRoomIdAndAccountIdTofindConcentrateRecordIdRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/2.
//

import Foundation

public struct UseInviteRoomIdAndAccountIdTofindConcentrateRecordIdRequest: Encodable {
    public let inviteRoomId: UUID
    public let accountId: UUID
}
