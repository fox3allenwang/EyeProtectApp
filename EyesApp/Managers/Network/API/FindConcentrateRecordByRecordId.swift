//
//  FindConcentrateRecordByRecordId.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import Foundation

struct FindConcentrateRecordByRecordIdRequest: Encodable {
    
    let recordId: UUID
}

struct FindConcentrateRecordByRecordIdResponse: Decodable {
    
    let picture: String
    
    let description: String
}
