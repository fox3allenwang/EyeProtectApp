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
        
        // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        
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
    
    // MARK: - callFriendInviteListAPI
    func callApiFriendInviteList(accountId: UUID) {
        let request = GetFriendInviteListRequest(accountId: accountId)
        
        Task {
            do {
                let result: GeneralResponse<GetFriendInviteListResponse> = try await NetworkManager().requestData(method: .post,
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
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 將Data轉成String
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserPreferences.shared.deviceToken = deviceTokenString
        print("deviceTokenString: \( UserPreferences.shared.deviceToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // 打通知會做的事
        if notification.request.content.body.contains("傳送了好友邀請給你") {
            callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        }
        
        if notification.request.content.body.contains("和你成為朋友了！") {
            NotificationCenter.default.post(name: .addFriend, object: nil)
        }
        
        if notification.request.content.body.contains("向你傳送專注邀請") {
            let messageComponents = notification.request.content.body.components(separatedBy: " ")
            let sendName = messageComponents[0]
            NotificationCenter.default.post(name: .showConcentrateInvite, object: nil, userInfo: ["inviteRoomId": notification.request.content.body.suffix(36),
                                                                                                  "sendName": sendName])
        }
        
        return [.banner, .badge, .sound]
    }
    
}
