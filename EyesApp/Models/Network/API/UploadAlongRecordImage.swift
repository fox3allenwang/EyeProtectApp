//
//  UploadAlongRecordImage.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/1.
//

import Foundation

struct UploadAlongRecordImageRequest: Encodable {
    
    let recordId: UUID
    
    let image: String
    
    let description: String
}
