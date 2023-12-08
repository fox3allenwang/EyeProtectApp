//
//  AddConcentrateRecord.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/23.
//

import Foundation

struct AddConcentrateRecordRequest: Encodable {
    
    let accountId: UUID
    
    let hostAccountId: UUID
    
    let startTime: String
    
    let concentrateTime: String
    
    let restTime: String
    
    let withFriends: [UUID]
}
