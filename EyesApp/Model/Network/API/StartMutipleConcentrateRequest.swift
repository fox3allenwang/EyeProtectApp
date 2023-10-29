//
//  StartMutipleConcentrateRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/30.
//

import Foundation

public struct StartMutipleConcentrateRequest: Encodable {
    public let inviteRoomId: UUID
    public let startTime: String
    public let concentrateTime: String
    public let restTime: String
}
