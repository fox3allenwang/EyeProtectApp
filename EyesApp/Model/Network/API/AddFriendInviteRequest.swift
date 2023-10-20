//
//  AddFriendInviteRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

public struct AddFriendInviteRequest: Encodable {
    public let accountId: UUID
    public let name: String
    public let email: String
}
