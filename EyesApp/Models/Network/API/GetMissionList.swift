//
//  GetMissionList.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/1.
//

import Foundation

struct GetMissionListRequest: Codable {
    
}

struct GetMissionListResponse: Decodable {
    
    let missionID: UUID
    
    let title: String
    
    let progress: Int
    
    let progressType: String
}
