//
//  NetworkConstants.swift
//  EyesApp
//
//  Created by Wang Allen on 2023/6/29.
//

import Foundation

struct NetworkConstants {
    
    static let httpBaseUrl = "http://"
    static let httpsBaseUrl = "https://"
    static let webSocketBaseUrl = "ws://"
    static let server = "192.168.8.156:8080"
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case xml = "application/xml"
        case x_www_form_urlencoded = "application/x-www-form-urlencoded"
    }
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum RequestError: Error {
    case unknownError(Error)
    case connectionError
    case authorizationError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case internalError
    case badGateway
    case jsonDecodeFailed(Error)
    case badRequest
}

// API 的網址
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
}
