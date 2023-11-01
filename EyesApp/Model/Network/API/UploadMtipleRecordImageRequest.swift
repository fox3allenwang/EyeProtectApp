//
//  UploadMtipleRecordImageRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/1.
//

import Foundation

public struct UploadMtipleRecordImageRequest: Encodable {
    public let inviteRoomId: UUID
    public let accountId: UUID
    public let image: String
    public let description: String
}
