//
//  NetworkManager.swift
//  EyesApp
//
//  Created by Wang Allen on 2023/6/29.
//

import Foundation
import SwiftHelpers

final class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    func requestData<E, D>(method: HTTP.HTTPMethod,
                           path: ApiPathConstants,
                           parameters: E,
                           needToken: Bool) async throws -> D where E: Encodable, D: Decodable {
        let urlRequest = handleHTTPMethod(method, path, parameters, needToken)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = (response as? HTTPURLResponse) else {
                throw URLError(.badServerResponse)
            }
            let statusCode = response.statusCode
            guard (200 ... 299).contains(statusCode) else {
                switch statusCode {
                case 400:
                    throw HTTP.HTTPStatus.badRequest
                case 401:
                    throw HTTP.HTTPStatus.unauthorized
                case 404:
                    throw HTTP.HTTPStatus.notFound
                case 500:
                    throw HTTP.HTTPStatus.internalServerError
                case 502:
                    throw HTTP.HTTPStatus.badGateway
                case 503:
                    throw HTTP.HTTPStatus.serviceUnavailable
                default:
                    throw URLError(.badServerResponse)
                }
            }
            do {
                let result = try JSONDecoder().decode(D.self, from: data)
                
                #if DEBUG
                printNetworkProgress(urlRequest, parameters, result)
                #endif
                
                return result
            } catch {
                print("=====================ERROR DATA=====================")
                print(data.base64EncodedString().utf8)
                print("====================================================")
                throw NetworkError.jsonDecodeFailed(error as! DecodingError)
            }
        } catch {
            print(error.localizedDescription)
            throw NetworkError.unknownError(error)
        }
    }
    
    private func requestWithURL(url: String, parameters: [String : String]?) -> URL? {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        urlComponents.queryItems = []
        parameters?.forEach { key, value in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return urlComponents.url
    }
    
    private func handleHTTPMethod<E>(_ method: HTTP.HTTPMethod,
                                     _ path: ApiPathConstants,
                                     _ parameters: E,
                                     _ needToken: Bool) -> URLRequest where E: Encodable {
        let baseURL = NetworkConstants.BaseUrl.http.rawValue + NetworkConstants.server
        let url = URL(string: baseURL + path.rawValue)!
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 50)
        let contentType = HTTP.HTTPHeaderFields.contentType.rawValue
        let json = HTTP.HTTPContentType.json.rawValue
        let authentication = HTTP.HTTPHeaderFields.authentication.rawValue
        let jwtToken = UserPreferences.shared.jwtToken
        
        if needToken {
            urlRequest.allHTTPHeaderFields = [
                contentType : json,
                authentication : "Bearer \(jwtToken)"
            ]
        } else {
            urlRequest.allHTTPHeaderFields = [
                contentType : json
            ]
        }
        
        urlRequest.httpMethod = method.rawValue
        
        let dict1 = try? parameters.toDictionary()
        
        switch method {
        case .get:
            let parameters = dict1 as? [String : String]
            urlRequest.url = requestWithURL(url: urlRequest.url?.absoluteString ?? "",
                                            parameters: parameters ?? [:])
        default:
            urlRequest.httpBody = try? JSON.toJsonData(data: parameters)
        }
        return urlRequest
    }
    
    private func printNetworkProgress<E, D>(_ urlRequest: URLRequest,
                                            _ parameters: E,
                                            _ results: D) where E: Encodable, D: Decodable {
        #if DEBUG
        print("=======================================")
        print("- URL: \(urlRequest.url?.absoluteString ?? "")")
        print("- Header: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("---------------Request-----------------")
        print(parameters)
        print("---------------Response----------------")
        print(results)
        print("=======================================")
        #endif
    }
}
