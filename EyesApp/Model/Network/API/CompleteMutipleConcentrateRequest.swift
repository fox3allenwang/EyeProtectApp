//
//  CompleteMutipleConcentrateRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/31.
//

import Foundation

public struct CompleteMutipleConcentrateRequest: Encodable {
    public let accountId: UUID
    public let inviteRoomId: UUID
    public let endTime: String
}
