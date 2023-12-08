//
//  NetworkConstants.swift
//  EyesApp
//
//  Created by Wang Allen on 2023/6/29.
//

import Foundation

struct NetworkConstants {
    
    enum BaseUrl: String {
        
        case http = "http://"
        
        case https = "https://"
        
        case websocket = "ws://"
    }
    
    static let server = "192.168.1.223:8080"
}

enum NetworkError: Error {
    
    case unknownError(Error)
    
    case jsonDecodeFailed(Error)
}

/// API 的網址
enum ApiPathConstants: String {
    
    case login = "/api/account"
    
    case register = "/api/account/register"
    
    case uploadImage = "/api/account/uploadImage"
    
    case getPersonInformation = "/api/account/getAccountPersonInformation"
    
    case getFriendList = "/api/account/getFriendList"
    
    case getMissionList = "/api/missionList/getAll"
    
    case logout = "/api/account/logout"
    
    case addFriendInvite = "/api/account/addFriendInvite"
    
    case getFriendInviteList = "/api/account/getFriendInviteList"
    
    case addFriend = "/api/account/addFriend"
    
    case rejectFriendInvite = "/api/account/rejectFriendInvite"
    
    case addConcentrateRecord = "/api/concentrateRecord/addConcentrateRecord"
    
    case giveUpConcentrateRecord = "/api/concentrateRecord/giveUpConcentrateRecord"
    
    case completeConcentrateRecord = "/api/concentrateRecord/completeConcentrateRecord"
    
    case wsInviteRoom = "/api/inviteRoomWebsocket/"
    
    case createInviteRoom = "/api/inviteConcentrateRoomController/createInviteRoom"
    
    case addFriendToInviteRoom = "/api/inviteConcentrateRoomController/addFriendToInviteRoom"
    
    case addToInviteRoom = "/api/inviteConcentrateRoomController/addToInviteRoom"
    
    case refreshInviteRoomMemberList = "/api/inviteConcentrateRoomController/refreshInviteRoomMemberList"
    
    case removeToInviteRoom = "/api/inviteConcentrateRoomController/removeToInviteRoom"
    
    case removeInviteRoom = "/api/inviteConcentrateRoomController/removeInviteRoom"
    
    case startMutipleConcentrate = "/api/inviteConcentrateRoomController/startMutipleConcentrate"
    
    case wsMutipleConcentrate = "/api/mutipleConcentrateWebSocketService/"
    
    case findByInviteRoomIdForConcentrateAndRestTime = "/api/concentrateRecord/findByInviteRoomIdForConcentrateAndRestTime"
    
    case findAccountAPI = "/api/account/findAccount"
    
    case completeMutipleConcentrate = "/api/concentrateRecord/completeMutipleConcentrate"
    
    case uploadAlongRecordImage = "/api/concentrateRecord/uploadAlongRecordImage"
    
    case uploadMtipleRecordImage = "/api/concentrateRecord/uploadMtipleRecordImage"
    
    case addConcentrateToNews = "/api/news/addConcentrateToNews"
    
    case useInviteRoomIdAndAccountIdTofindConcentrateRecordId = "/api/concentrateRecord/useInviteRoomIdAndAccountIdTofindConcentrateRecordId"
    
    case loadNews = "/api/news/loadNews"
    
    case addNewsReply = "/api/newsReply/addNewsReply"
    
    case loadNewsReply = "/api/newsReply/loadNewsReply"
    
    case deleteReply = "/api/newsReply/deleteReply"
    
    case editReply = "/api/newsReply/editReply"
    
    case findSelfConcentrateRecord = "/api/concentrateRecord/findSelfConcentrateRecord"
    
    case findConcentrateRecordByRecordId = "/api/concentrateRecord/findConcentrateRecordByRecordId"
    
    case loadOnePersonNews = "/api/news/loadOnePersonNews"
    
    case findTodayMissionComplete = "/api/missionCompleteCount/findTodayMissionComplete"
    
    case addMissionComplete = "/api/missionCompleteCount/addMissionComplete"
}
