//
//  GetFriendListRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/1.
//

import Foundation

public struct GetFriendListRequest: Codable {
    
    public var accountId: UUID
    
    enum CodingKeys: String, CodingKey {
        
        case accountId
        
    }
    
    public init(accountId: UUID) {
        
        self.accountId = accountId
    }
}

public struct GetFriendListResponse: Decodable {
    
    public var result: Int
    
    public var data: [friendInfo]
    
    public var message: String
}

public struct friendInfo: Decodable {
    
    public var accountId: String
    
    public var email: String
    
    public var name: String
    
    public var image: String
    
}
