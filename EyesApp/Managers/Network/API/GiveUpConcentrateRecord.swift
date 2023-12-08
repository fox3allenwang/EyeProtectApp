//
//  GiveUpConcentrateRecord.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/23.
//

import Foundation

struct GiveUpConcentrateRecordRequest: Encodable {
    
    let recordId: UUID
    
    let endTime: String
}
