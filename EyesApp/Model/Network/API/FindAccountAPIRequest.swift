//
//  FindAccountAPIRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/31.
//

import Foundation

public struct FindAccountAPIRequest: Encodable {
    public let accountId: UUID
}

public struct FindAccountAPIResponse: Decodable {
    public let accountId: UUID
    public let name: String
    public let image: String
}
