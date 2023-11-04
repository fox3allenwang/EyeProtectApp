//
//  LoadNewsReplyRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import Foundation

public struct LoadNewsReplyRequest: Encodable {
    public let newsId: UUID
}

public struct LoadNewsReplyResponse: Decodable {
    public let replyList: [ReplyItem]
}

public struct ReplyItem: Decodable {
    public let replyId: UUID
    public let newsId: UUID
    public let accountId: UUID
    public let accountName: String
    public let accountImage: String
    public let message: String
    public let time: String
}
