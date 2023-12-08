//
//  UNNotificationManager.swift
//  EyesApp
//
//  Created by Leo Ho on 2023/12/8.
//

import UIKit

class UNNotificationManager: NSObject {
    
    static let shared = UNNotificationManager()
    
    private let content = UNMutableNotificationContent()
    
    func add(subtitle: String,
             body: String,
             badge: NSNumber,
             sound: UNNotificationSound = .default,
             identifier: String) async throws {
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        content.sound = sound
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        try await UNUserNotificationCenter.current().add(request)
        print("成功建立通知...")
    }
}
