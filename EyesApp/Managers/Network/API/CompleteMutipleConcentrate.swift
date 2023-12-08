//
//  CompleteMutipleConcentrate.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/31.
//

import Foundation

struct CompleteMutipleConcentrateRequest: Encodable {
    
    let accountId: UUID
    
    let inviteRoomId: UUID
    
    let endTime: String
}
