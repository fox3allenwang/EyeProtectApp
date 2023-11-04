//
//  AddNewsReplyRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import Foundation

public struct AddNewsReplyRequest: Encodable {
    public let accountId: UUID
    public let newsId: UUID
    public let message: String
    public let time: String
}
