//
//  FindTodayMissionComplete.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/14.
//

import Foundation

struct FindTodayMissionCompleteRequest: Encodable {
    
    let accountId: UUID
    
    let date: String
}

struct FindTodayMissionCompleteResponse: Decodable {
    
    let concentrateTime: Int
    
    let missionId: [UUID]
}
