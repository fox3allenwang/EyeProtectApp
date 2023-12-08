//
//  LoadNewsReply.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import Foundation

struct LoadNewsReplyRequest: Encodable {
    
    let newsId: UUID
}

struct LoadNewsReplyResponse: Decodable {
    
    let replyList: [ReplyItem]
    
    struct ReplyItem: Decodable {
        
        let replyId: UUID
        
        let newsId: UUID
        
        let accountId: UUID
        
        let accountName: String
        
        let accountImage: String
        
        let message: String
        
        let time: String
    }
}
