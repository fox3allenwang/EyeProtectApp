//
//  UploadAlongRecordImageRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/1.
//

import Foundation

public struct UploadAlongRecordImageRequest: Encodable {
    public let recordId: UUID
    public let image: String
    public let description: String
}
