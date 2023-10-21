//
//  AddFriendRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

public struct AcceptOrRejectFriendRequest: Encodable {
    public let reciveAccountId: UUID
    public let sendAccountId: UUID
}
