//
//  GetMissionListRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/1.
//

import Foundation

public struct GetMissionListRequest: Codable {
    
}

public struct GetMissionListResponse: Decodable {
    
    public var missionID: UUID
    
    public var title: String
    
    public var progress: Int
    
    public var progressType: String
    
}
