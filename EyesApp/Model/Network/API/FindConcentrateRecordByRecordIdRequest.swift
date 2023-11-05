//
//  FindConcentrateRecordByRecordIdRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import Foundation

public struct FindConcentrateRecordByRecordIdRequest: Encodable {
    public let recordId: UUID
}

public struct FindConcentrateRecordByRecordIdResponse: Decodable {
    public let picture: String
    public let description: String
}
