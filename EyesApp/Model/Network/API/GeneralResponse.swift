//
//  GeneralResponse.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/24.
//

import Foundation

public struct GeneralResponse<T: Decodable>: Decodable {
    
    public let result: Int
    
    public var data: T?
    
    public let message: String
}
