//
//  LocalDatabase.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/24.
//

import Foundation

class LocalDatabase: NSObject {
    
    static let shared = LocalDatabase()
    
    var timeRecord: [Date] = []
    var statusRecord: [Int] = []
}
