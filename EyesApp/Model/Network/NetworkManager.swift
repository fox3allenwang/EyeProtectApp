//
//  NetworkManager.swift
//  EyesApp
//
//  Created by Wang Allen on 2023/6/29.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    public func requestData<E, D>(method: HTTPMethod,
                                  path: ApiPathConstants,
                                  parameters: E) async throws -> D where E: Encodable, D: Decodable {
        let urlRequest = handleHTTPMethod(method, path, parameters)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = (response as? HTTPURLResponse) else {
                throw RequestError.invalidResponse
            }
            let statusCode = response.statusCode
            guard (200 ... 299).contains(statusCode) else {
                switch statusCode {
                case 400:
                    throw RequestError.badRequest
                case 401:
                    throw RequestError.authorizationError
                case 404:
                    throw RequestError.notFound
                case 500:
                    throw RequestError.internalError
                case 502:
                    throw RequestError.badGateway
                case 503:
                    throw RequestError.serverUnavailable
                default:
                    throw RequestError.invalidResponse
                }
            }
            do {
                let result = try JSONDecoder().decode(D.self, from: data)
                
                #if DEBUG
                printNeworkProgress(urlRequest, parameters, result)
                #endif
                
                return result
            } catch {
                throw RequestError.jsonDecodeFailed(error as! DecodingError)
            }
        } catch {
            print(error.localizedDescription)
            throw RequestError.unknownError(error)
        }
    }
    
    private func requestWithURL(urlString: String, parameters: [String : String]?) -> URL? {
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        urlComponents.queryItems = []
        parameters?.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return urlComponents.url
    }
    
    private func handleHTTPMethod<E: Encodable>(_ method: HTTPMethod,
                                                _ path: ApiPathConstants,
                                                _ parameters: E?) -> URLRequest {
        let baseURL = NetworkConstants.httpBaseUrl + NetworkConstants.server
        let url = URL(string: baseURL + path.rawValue)!
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let httpType = NetworkConstants.ContentType.json.rawValue
        urlRequest.allHTTPHeaderFields = [NetworkConstants.HttpHeaderField.contentType.rawValue : httpType]
        urlRequest.httpMethod = method.rawValue
        
        let dict1 = try? parameters.asDictionary()
        
        switch method {
        case .get:
            let parameters = dict1 as? [String : String]
            urlRequest.url = requestWithURL(urlString: urlRequest.url?.absoluteString ?? "", parameters: parameters ?? [:])
        default:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict1 ?? [:], options: .prettyPrinted)
        }
        return urlRequest
    }
    
    private func printNeworkProgress<E: Encodable, D: Decodable>(_ urlRequest: URLRequest, _ parameters: E, _ results: D) {
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
