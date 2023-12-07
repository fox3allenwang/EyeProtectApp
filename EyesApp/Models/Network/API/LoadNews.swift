//
//  LoadNews.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/3.
//

import Foundation

struct LoadNewsRequest: Encodable {
    
    let accountId: UUID
}

struct LoadNewsResponse: Decodable {
    
    let newsItems: [NewsItem]
    
    struct NewsItem: Decodable {
        
        let newsId: UUID
        
        let sendAccountId: UUID
        
        let sendAccountName: String
        
        let sendAccountImage: String
        
        let title: String
        
        let description: String
        
        let newsPicture: String
        
        let time: String
        
        let replyCount: Int
    }
}
