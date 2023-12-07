//
//  StartMutipleConcentrate.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/30.
//

import Foundation

struct StartMutipleConcentrateRequest: Encodable {
    
    let inviteRoomId: UUID
    
    let startTime: String
    
    let concentrateTime: String
    
    let restTime: String
}
