//
//  loadNewsRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/3.
//

import Foundation

public struct LoadNewsRequest: Encodable {
    public let accountId: UUID
}

public struct LoadNewsResponse: Decodable {
    public let newsItems: [NewsItem]
}

public struct NewsItem: Decodable {
    public let newsId: UUID
    public let sendAccountId: UUID
    public let sendAccountName: String
    public let sendAccountImage: String
    public let title: String
    public let description: String
    public let newsPicture: String
    public let time: String
    public let replyCount: Int
}
