//
//  FindByInviteRoomIdForConcentrateAndRestTime.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/30.
//

import Foundation

struct FindByInviteRoomIdForConcentrateAndRestTimeRequest: Encodable {
    
    let inviteRoomId: UUID
}

struct FindByInviteRoomIdForConcentrateAndRestTimeResponse: Decodable {
    
    let concentrateTime: String
    
    let restTime: String
}
