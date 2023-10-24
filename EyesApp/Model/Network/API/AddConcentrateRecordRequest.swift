//
//  AddConcentrateRecordRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/23.
//

import Foundation

public struct AddConcentrateRecordRequest: Encodable {
    public let accountId: UUID
    public let startTime: String
    public let concentrateTime: String
    public let restTime: String
    public let withFriends: [UUID]
}
