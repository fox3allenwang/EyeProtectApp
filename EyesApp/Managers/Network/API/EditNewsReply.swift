//
//  EditNewsReply.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import Foundation

struct EditNewsReplyRequest: Encodable {
    
    let replyId: UUID
    
    let message: String
}
