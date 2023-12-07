//
//  Formatter.swift
//  EyesApp
//
//  Created by Leo Ho on 2023/12/7.
//

import Foundation

struct Formatter {
    
    private let dateFormatter = DateFormatter()
    
    func convertDate(from str: String, format: String) -> Date? {
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: str)
        return date
    }
    
    func convertDate(from date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: date)
        return str
    }
}
