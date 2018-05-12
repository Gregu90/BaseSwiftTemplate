//
//  RESTClient.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

enum HTTPStatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case gone = 410
    case teapot = 418
    case updateRequired = 426
}

enum HTTPStatusCodeGroup: Int {
    case info = 100
    case success = 200
    case redirect = 300
    case client = 400
    case server = 500
    case unknown = 999
    
    init(httpStatusCode code: Int)
    {
        switch code {
        case 100...199: self = .info
        case 200...299: self = .success
        case 300...399: self = .redirect
        case 400...499: self = .client
        case 500...599: self = .server
        default: self = .unknown
        }
    }
}

enum NetworkError
{
    case servcerConnectionFail
    case serverCommunicationFail
    case noInternetConnection
    case unknown
    
    init(urlError: URLError)
    {
        switch urlError.code {
        case .cannotConnectToHost,
             .timedOut,
             .cannotFindHost,
             .dnsLookupFailed,
             .resourceUnavailable: self = .servcerConnectionFail
        case .badServerResponse: self = .serverCommunicationFail
        case .networkConnectionLost,
             .notConnectedToInternet: self = .noInternetConnection
        default: self = .unknown
        }
    }
}

class RESTClient
{
    typealias StandardCompletionClosure = (_ request: URLRequest, _ response: Any?, _ statusCode: Int, _ error: Error?) -> Void
    
    var networkActivityIndicatorEnabled = true
    
    fileprivate var requestsInProgress: Int = 0
    fileprivate var manager: Alamofire.SessionManager
    fileprivate var baseURL: String!
    
    init()
    {
        self.manager = SessionManager.default
    }
    
    func setup(_ baseURL: String)
    {
        self.baseURL = baseURL
    }
    
    fileprivate static let authorizationHeaderKey = "Authorization"
    
    var authorizationHeaderValue: String?
    
    func authorizationHeader() -> [String: String]?
    {
        if let header = self.authorizationHeaderValue {
            return [RESTClient.authorizationHeaderKey : header]
        }else {
            return nil
        }
    }
    
    func authorizationHeaderNoCredentials() -> [String: String]?
    {
        if let header = self.authorizationHeaderValue {
            return [RESTClient.authorizationHeaderKey : header]
        }else {
            return nil
        }
    }
    
    
    
    func makeRequest(method: Alamofire.HTTPMethod, path: String, parameters: [String: Any]? = nil, header: [String: String]? = nil, encoding: Alamofire.ParameterEncoding? = nil, completion: StandardCompletionClosure?)
    {
        var headers: [String: String] = [:]

        if let authorizationHeaders = self.authorizationHeader() {
            headers.update(authorizationHeaders)
        }
        
        DLog("authorizationHeaders: \(header)")
        
        var encoding = encoding
        if encoding == nil {
            encoding = method.defaultParameterEncoding()
        }
        let url = self.baseURL + path
        self.requestStarted()
        DLog("path: \(url)")
        DLog("headers: \(headers)")
        DLog("parameters: \(parameters)")
        let request = self.manager.request(url, method: method, parameters: parameters, encoding: encoding!, headers: headers)
        let _ = self.handle(request: request, withCompletion: completion)
        
    }
    
    func handle(request: Alamofire.DataRequest, withCompletion completion: StandardCompletionClosure?) -> Alamofire.Request
    {
        request
            .validate(statusCode: (200..<400))
            .responseJSON {
                [weak self](dataResponse) -> Void in
                if let sself = self {
                    sself.requestStopped()
                    
                    var statusCode: Int = 0
                    if let response = dataResponse.response {
                        statusCode = response.statusCode
                    }
                    var error = dataResponse.result.error
                    //wiping out error when there's no content and server doesn't return 204
                    if let e = error as? AFError {
                        if case AFError.responseSerializationFailed(let reason) = e {
                            switch reason {
                            case .inputDataNil, .inputDataNilOrZeroLength:
                                error = nil
                            default: break
                            }
                        }
                    }
                    var response = dataResponse.result.value
                    if let _ = error {
                        sself.logError(response: dataResponse)
                        if statusCode == HTTPStatusCode.unauthorized.rawValue {
                            sself.got401()
                        }
                        if let data = dataResponse.data {
                            response = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        }
                        
                    }
                    completion?(dataResponse.request!, response, statusCode, error)
                }
        }
        return request
    }
    
    ///For overrides i.e. when handling logout
    func got401()
    {}
    
    private func requestStarted()
    {
        self.requestsInProgress += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = self.networkActivityIndicatorEnabled
    }
    
    private func requestStopped()
    {
        self.requestsInProgress -= 1
        if self.requestsInProgress < 0 {
            self.requestsInProgress = 0
        }
        if self.requestsInProgress == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func logError(response: DataResponse<Any>)
    {
        DLog(response.debugDescription)
        var dataString: String? = nil
        if let data = response.data {
            dataString = String(data: data, encoding: .utf8)
        }
        DLog("[RESPONSE]: \(dataString ?? "")")
    }
    
}

extension Alamofire.HTTPMethod
{
    func defaultParameterEncoding () -> Alamofire.ParameterEncoding
    {
        switch self {
        case .get, .head, .delete: return Alamofire.URLEncoding.default
        default: return Alamofire.JSONEncoding.default
        }
    }
}

