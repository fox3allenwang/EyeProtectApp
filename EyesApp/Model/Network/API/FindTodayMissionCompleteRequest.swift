//
//  FindTodayMissionCompleteRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/14.
//

import Foundation

public struct FindTodayMissionCompleteRequest: Encodable {
    public let accountId: UUID
    public let date: String
}

public struct FindTodayMissionCompleteResponse: Decodable {
    public let concentrateTime: Int
    public let missionId: [UUID]
}
