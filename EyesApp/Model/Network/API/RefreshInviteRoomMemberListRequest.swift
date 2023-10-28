//
//  RefreshInviteRoomMemberListRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import Foundation

public struct RefreshInviteRoomMemberListRequest: Encodable {
    public let inviteRoomId: UUID
}

public struct RefreshInviteRoomMemberListResponse: Decodable {
    public let memberList: [FindAccountResponse]
}

public struct FindAccountResponse: Decodable {
    public let accountId: UUID
    public let name: String
    public let image: String
}
