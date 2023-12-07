//
//  GetPersonInformation.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/13.
//

import Foundation

struct GetPersonInformationRequest: Codable {
    
    let accountId: UUID
}

struct GetPersonInformationResponse: Decodable {

    let accountId: String
    
    let email: String
    
    let name: String
    
    let dor: String
    
    let image: String
}
