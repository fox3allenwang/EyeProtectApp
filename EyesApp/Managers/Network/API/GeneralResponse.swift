//
//  GeneralResponse.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/24.
//

import Foundation

struct GeneralResponse<T: Decodable>: Decodable {
    
    let result: Int
    
    let data: T
    
    let message: String
}
