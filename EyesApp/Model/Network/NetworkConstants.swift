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
    case login = "192.168.166.226:8080/api/account"
    case logout = "172.20.10.4:5000/account/logout"
    case cabinet = "172.20.10.4:5000/account/inventory"
}
