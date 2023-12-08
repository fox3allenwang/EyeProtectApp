//
//  UploadImage.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/12.
//

import Foundation

struct UploadImageRequest: Codable {
    
    let accountId: UUID
    
    let image: String
}
