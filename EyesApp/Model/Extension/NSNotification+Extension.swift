//
//  NSNotification+Extension.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/21.
//

import Foundation

extension NSNotification.Name {
    static let addFriendInviteViewDismiss = Notification.Name("addFriendInviteViewDismiss")
    static let reciveFriendInvite = Notification.Name("reciveFriendInvite")
    static let addFriend = Notification.Name("addFriend")
    static let showConcentrateInvite = Notification.Name("showConcentrateInvite")
    static let dismissAddInviteView = Notification.Name("dismissAddInviteView")
    static let goToConcentrate = Notification.Name("goToConcentrate")
    static let reloadMissionStatus = Notification.Name("reloadMissionStatus")
    static let concentrateCackgroundNotification = Notification.Name("concentrateCackgroundNotification")
}
