//
//  AppDelegate.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/9.
//

import UIKit
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        // 請求通知權限
        requestUNUserNotificationAuthorization()
        
        // 註冊遠程通知
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - UNUserNotificationCenter

extension AppDelegate {
    
    /// 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
    func requestUNUserNotificationAuthorization() {
        Task {
            do {
                let options: UNAuthorizationOptions = [.alert,.sound,.badge, .carPlay]
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: options)
                if granted {
                    print("允許")
                } else {
                    print("不允許")
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 將Data轉成String
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserPreferences.shared.deviceToken = deviceTokenString
        print("deviceTokenString: \( UserPreferences.shared.deviceToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // 打通知會做的事
        if notification.request.content.body.contains("傳送了好友邀請給你") {
            await callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        }
        
        if notification.request.content.body.contains("和你成為朋友了！") {
            NotificationCenter.default.post(name: .addFriend, object: nil)
        }
        
        if notification.request.content.body.contains("向你傳送專注邀請") {
            let messageComponents = notification.request.content.body.components(separatedBy: " ")
            let sendName = messageComponents[0]
            let inviteRoomId = notification.request.content.body.suffix(36)
            NotificationCenter.default.post(name: .showConcentrateInvite,
                                            object: nil,
                                            userInfo: [
                                                "inviteRoomId" : inviteRoomId,
                                                "sendName" : sendName
                                            ])
        }
        
        return [.banner, .badge, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let nextVC = PersonalViewController()
    }
}

// MARK: - Call FriendInviteList API

extension AppDelegate {
    
    func callApiFriendInviteList(accountId: UUID) async {
        let request = GetFriendInviteListRequest(accountId: accountId)
        
        do {
            let manager = NetworkManager.shared
            let result: GeneralResponse<GetFriendInviteListResponse> = try await manager.requestData(method: .post,
                                                                                                     path: .getFriendInviteList,
                                                                                                     parameters: request,
                                                                                                     needToken: true)
            if result.message == "此帳號目前有好友邀請" {
                NotificationCenter.default.post(name: .reciveFriendInvite, object: nil)
            }
        } catch {
            print(error)
        }
    }
}
