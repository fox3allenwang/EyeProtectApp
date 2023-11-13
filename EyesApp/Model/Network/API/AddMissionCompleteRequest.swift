//
//  AddMissionCompleteRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/14.
//

import Foundation

public struct AddMissionCompleteRequest: Encodable {
    public let missionId: UUID
    public let accountId: UUID
    public let date: String
}
