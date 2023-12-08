//
//  AddMissionComplete.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/14.
//

import Foundation

struct AddMissionCompleteRequest: Encodable {
    
    let missionId: UUID
    
    let accountId: UUID
    
    let date: String
}
