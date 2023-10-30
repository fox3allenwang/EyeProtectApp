//
//  FindByInviteRoomIdForConcentrateAndRestTimeRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/30.
//

import Foundation

public struct FindByInviteRoomIdForConcentrateAndRestTimeRequest: Encodable {
    public let inviteRoomId: UUID
}

public struct FindByInviteRoomIdForConcentrateAndRestTimeResponse: Decodable {
    public let concentrateTime: String
    public let restTime: String
}
