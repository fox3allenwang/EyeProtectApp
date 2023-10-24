//
//  GiveUpConcentrateRecordRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/23.
//

import Foundation

public struct GiveUpConcentrateRecordRequest: Encodable {
    public let recordId: UUID
    public let endTime: String
}
