//
//  NetworkManager.swift
//  EyesApp
//
//  Created by Wang Allen on 2023/6/29.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    func requestData<E: Encodable, D: Decodable>(method: HTTPMethod,
                                                 path: ApiPathConstants,
                                                 parameters: E?,
                                                 finish: @escaping (Result<D, RequestError>) -> Void) {
        
        let urlRequest = handleHTTPMethod(method, path, parameters)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                let errorCode = (response as? HTTPURLResponse)?.statusCode
                if error != nil {
                    finish(.failure(.unknownError))
                } else if errorCode == 502 {
                    finish(.failure(.badGateway))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    if let results = try? decoder.decode(D.self, from: data) {
                        #if DEBUG
                        self.printNeworkProgress(urlRequest, parameters, results)
                        #endif
                        finish(.success(results))
                    } else {
                        finish(.failure(.jsonDecodeFailed))
                    }
                }
            }
        }.resume()
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
        let baseURL = NetworkConstants.httpBaseUrl
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
