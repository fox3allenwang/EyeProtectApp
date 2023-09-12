//
//  GetPersonInfromationRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/13.
//

import Foundation

public struct GetPersonInfromationRequest: Codable {
    
    public var accountId: UUID
    
    enum CodingKeys: String, CodingKey {
        
        case accountId
        
    }
    
    public init(accountId: UUID) {
        
        self.accountId = accountId
    }
}

public struct GetPersonInfromationResponse: Decodable {

    public var accountId: String
    
    public var email: String
    
    public var name: String
    
    public var dor: String
    
    public var image: String
    
}
