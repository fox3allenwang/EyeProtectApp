//
//  GetFriendInviteListResponse.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

public struct GetFriendInviteListRequest: Encodable {
    public let accountId: UUID
}

public struct GetFriendInviteListResponse: Decodable {
    public let friendinviteInfo: [FriendinviteInfo]
}

public struct FriendinviteInfo: Decodable {
    public let accountId: String
    public let name: String
    public let email: String
    public let image: String
}
