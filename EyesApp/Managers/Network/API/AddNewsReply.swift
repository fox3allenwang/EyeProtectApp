//
//  AddNewsReply.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import Foundation

struct AddNewsReplyRequest: Encodable {
    
    let accountId: UUID
    
    let newsId: UUID
    
    let message: String
    
    let time: String
}
