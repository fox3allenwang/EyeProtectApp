//
//  WebSocketManager.swift
//  EyesApp
//
//  Created by Leo Ho on 2023/12/7.
//

import Foundation
import SwiftHelpers

final class WebSocketManager: NSObject {
    
    static let shared = WebSocketManager()
    
    weak var delegate: WebSocketManagerDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask!
    
    func connect(path: ApiPathConstants,
                 parameters: String,
                 sessionDescription: String) {
        let urlRequest = createURLRequest(path: path, parameters: parameters)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.sessionDescription = sessionDescription
        webSocketTask = session.webSocketTask(with: urlRequest)
        webSocketTask.resume()
    }
    
    func send(message: String) async throws {
        try await webSocketTask.send(.string(message))
    }
    
    func receive() async {
        do {
            let message = try await webSocketTask.receive()
            switch message {
            case .data(let data):
                print("Got Data \(data)")
            case .string(let string):
                print("Got RoomMember \(string)")
                delegate?.webSocket(self, didReceive: string)
                await receive()
            default:
                break
            }
        } catch {
            print("ws: \(error)")
            return
        }
    }
    
    func cancel() {
        webSocketTask.cancel()
    }
    
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        webSocketTask.cancel(with: closeCode, reason: reason)
    }
    
    private func createURLRequest(path: ApiPathConstants, parameters: String) -> URLRequest {
        let baseURL = NetworkConstants.BaseUrl.websocket.rawValue
        let server = NetworkConstants.server
        let url = URL(string: baseURL + server + path.rawValue + parameters)!
        
        var request = URLRequest(url: url)
        
        let authorization = HTTP.HTTPHeaderFields.authentication.rawValue
        request.allHTTPHeaderFields = [
            authorization : "Bearer \(UserPreferences.shared.jwtToken)"
        ]
        
        return request
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        Task {
            await delegate?.webSocket(self,
                                      session,
                                      webSocketTask: webSocketTask,
                                      didOpenWithProtocol: `protocol`)
        }
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        delegate?.webSocket(self,
                            session,
                            webSocketTask: webSocketTask,
                            didCloseWith: closeCode,
                            reason: reason)
    }
}

// MARK: - WebSocketManagerDelegate

protocol WebSocketManagerDelegate: NSObjectProtocol {
    
    func webSocket(_ webSocketManager: WebSocketManager,
                   _ session: URLSession,
                   webSocketTask: URLSessionWebSocketTask,
                   didOpenWithProtocol protocol: String?) async
    
    func webSocket(_ webSocketManager: WebSocketManager,
                   _ session: URLSession,
                   webSocketTask: URLSessionWebSocketTask,
                   didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                   reason: Data?)
    
    func webSocket(_ webSocketManager: WebSocketManager, didReceive message: String)
}
