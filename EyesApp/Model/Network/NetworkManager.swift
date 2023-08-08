//
//  NetworkManager.swift
//  EyesApp
//
//  Created by Wang Allen on 2023/6/29.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    public func requestData<E, D>(method: HTTPMethod,                                                   //  指剛剛在 NetWorkConstant 所定義的 HttpMethod 指定 Http 的協議
                                  path: ApiPathConstants,                                               //  給定 API 路徑
                                  parameters: E) async throws -> D where E: Encodable, D: Decodable {   //  parameters: 要帶給伺服器的參數   async: 異步進行  throws: 丟錯  where: 型別約束
        let urlRequest = handleHTTPMethod(method, path, parameters)                                     //  讓 handleHTTPMethod 去處理這三個參數並把結果賦給 urlRequest
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)                    //  try await 異步等待 URLSession.shared.data 的結果，並把結果給 data、response
            guard let response = (response as? HTTPURLResponse) else {
                throw RequestError.invalidResponse                                                      //  若沒有 response 就丟無效的 Response 的錯給呼叫 requestData 的 func
            }                                                                                           //  RequestError 也是在 NetWorkConstant 定義過的錯
            let statusCode = response.statusCode                                                        //  若 response 是存在的，就執行此判斷， 200 ... 299 為成功，其他則取得失敗結果丟錯
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
                let result = try JSONDecoder().decode(D.self, from: data)                               //  嘗試將取到的 data 以 D 的型別解碼並給 result
                
                #if DEBUG
                printNeworkProgress(urlRequest, parameters, result)                                     // 呼叫這個 func 去 print 結果
                #endif
                
                return result                                                                           // 回傳結果給呼叫 requestData 的 func
            } catch {
                throw RequestError.jsonDecodeFailed(error as! DecodingError)                            // 如果解碼失敗則丟出 .jsonDecodeFailed 的錯
            }
        } catch {
            print(error.localizedDescription)
            throw RequestError.unknownError(error)                                                      // 這邊是如果 URLSession.shared.data(for: urlRequest) 執行錯誤會丟的錯
        }
    }
    
    private func requestWithURL(urlString: String, parameters: [String : String]?) -> URL? {            // 直接將參數 append 到 API 路徑後面丟回 requestData 做 Request
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
        let baseURL = NetworkConstants.httpBaseUrl                                                                  // 給定伺服器的網域
        let url = URL(string: baseURL + path.rawValue)!                                                             // 將網域與 API 路徑結合
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)            // 設定 Request 的初始值  cachePolicy: Request 的緩存策略，這裡設為默認的 timeOut: 10 秒
        let httpType = NetworkConstants.ContentType.json.rawValue                                                   // 指定請求的 Body 為 JSON 在 NetworkConstants 有定義
        urlRequest.allHTTPHeaderFields = [NetworkConstants.HttpHeaderField.contentType.rawValue : httpType]         // 設定 HttpHeader （這裡只設置 Content-Type）
        urlRequest.httpMethod = method.rawValue                                                                     // 設定 urlRequest 的 HttpMethod
        
        let dict1 = try? parameters.asDictionary()                                                                  // 將我們要帶給伺服器的參數設為 Dictionary
        
        switch method {
        case .get:                                                                                                  // 判斷 Metho 若是 GET 則將剛剛轉完 Dictionary 的參數給 requestWithURL 做
            let parameters = dict1 as? [String : String]                                                            // 否則直接設在 body 帶給伺服器
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
