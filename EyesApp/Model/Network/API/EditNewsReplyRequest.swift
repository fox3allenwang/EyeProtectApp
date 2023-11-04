//
//  EditNewsReplyRequest.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import Foundation

public struct EditNewsReplyRequest: Encodable {
    public let replyId: UUID
    public let message: String
}
