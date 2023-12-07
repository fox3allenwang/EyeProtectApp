//
//  UploadMtipleRecordImage.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/1.
//

import Foundation

struct UploadMtipleRecordImageRequest: Encodable {
    
    let inviteRoomId: UUID
    
    let accountId: UUID
    
    let image: String
    
    let description: String
}
