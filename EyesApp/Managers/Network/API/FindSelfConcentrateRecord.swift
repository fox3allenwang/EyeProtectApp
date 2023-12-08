//
//  FindSelfConcentrateRecord.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import Foundation

struct FindSelfConcentrateRecordRequest: Encodable {
    
    let accountId: UUID
}

struct FindSelfConcentrateRecordResponse: Decodable {
    
    let concentrateRecordList: [SelfConcentrateRecordItem]
    
    struct SelfConcentrateRecordItem: Decodable {
        
        let recordId: UUID
        
        let accountId: UUID
        
        let hostAccountId: UUID
        
        let hostName: String
        
        let startTime: String
        
        let endTime: String
        
        let isFinished: Bool
        
        let concentrateTime: String
        
        let restTime: String
        
        let withFriends: [String]
    }
}
