//
//  UploadImageRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/12.
//

import Foundation

public struct UploadImageRequest: Codable {
    
    public var accountId: UUID
    
    public var image: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case accountId
        
        case image
    }
    
    public init(accountId: UUID,
                image: String) {
        
        self.accountId = accountId
        
        self.image = image
    }
}

