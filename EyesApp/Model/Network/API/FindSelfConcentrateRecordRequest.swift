//
//  FindSelfConcentrateRecordRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import Foundation

public struct FindSelfConcentrateRecordRequest: Encodable {
    public let accountId: UUID
}

public struct FindSelfConcentrateRecordResponse: Decodable {
    public let concentrateRecordList: [SelfConcentrateRecordItem]
}

public struct SelfConcentrateRecordItem: Decodable {
    public let recordId: UUID
    public let accountId: UUID
    public let hostAccountId: UUID
    public let hostName: String
    public let startTime: String
    public let endTime: String
    public let isFinished: Bool
    public let concentrateTime: String
    public let restTime: String
    public let withFriends: [String]
}
