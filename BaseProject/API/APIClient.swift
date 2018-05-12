//
//  APIClient.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

private let _SharedInstance = APIClient()

class APIClient : RESTClient
{
    class var sharedClient: APIClient
    {
        return _SharedInstance
    }
    
    override init()
    {
        super.init()
        
    }
    
    override func authorizationHeader() -> [String : String]?
    {
        if let token = Settings.currentUser?.token {
            return ["Authorization": "Bearer " + token]
        } else {
            return nil
        }
    }
    
    var friends: [Friend] = []
    
    //MARK: - Requests
    
    func getToken(_ code: String, completion: @escaping ((_ token: UserToken?, _ error: Error?) -> ()))
    {
        self.setup("https://auth.gog.com/")
        let params: [String: String] = ["client_id": APIConstants.LoginConfig.client_id.string,
                                        "client_secret": APIConstants.LoginConfig.client_secret.string,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": APIConstants.LoginConfig.redirect_url.string]
        
        self.makeRequest(method: .get, path: APIConstants.Paths.token.string, parameters: params) { (request, response, statusCode, error) in
            
            if let error = error {
                completion(nil, error)
            } else {
                if let mapped = Mapper<UserToken>().map(JSONObject: response) {
                    var user = mapped
                    user.code = code
                    self.setup("https://api.gog.com/")
                     completion(user, nil)
                    
                } else {
                    completion(nil, error)
                }
            }
        }
        
    }
    
    func refreshToken(_ user: UserToken, completion: @escaping ((_ token: UserToken?, _ error: Error?) -> ()))
    {
        self.setup("https://auth.gog.com/")
        let params: [String: String] = ["client_id": APIConstants.LoginConfig.client_id.string,
                                        "client_secret": APIConstants.LoginConfig.client_secret.string,
                                        "grant_type": "refresh_token",
                                        "code": user.code ?? "",
                                        "refresh_token": user.refreshToken ?? ""]
        
        self.makeRequest(method: .get, path: APIConstants.Paths.token.string, parameters: params) { (request, response, statusCode, error) in
            
            if let error = error {
                completion(nil, error)
            } else {
                if let mapped = Mapper<UserToken>().map(JSONObject: response) {
                    var newUser = mapped
                    newUser.code = user.code
                    Settings.currentUser = newUser
                    DLog("refrshed User: \(newUser)")
                    self.setup("https://api.gog.com/")
                    completion(user, nil)
                    
                } else {
                    completion(nil, error)
                }
            }
        }
        
    }
    
    
    func getFriends(userId: String, completion: @escaping ((_ friends: [Friend], _ error: Error?) -> ()))
    {
        self.setup("https://chat.gog.com/")
        
        self.makeRequest(method: .get, path: APIConstants.Paths.friends(userId: userId).string) {
            (request, response, statusCode, error) in
            var friends: [Friend] = []
            if let error = error {
                completion(friends, error)
            } else {
                DLog("response \(response)")
                var object = response
                if let mapped = Mapper<FriendList>().map(JSONObject: response) {
                    DLog("mapped Friends: \(mapped)")
                    friends = mapped.items
                    self.friends = friends
                    completion(friends, nil)
                } else {
                    completion(friends, error)
                }
            }
        }
        
    }
    
//    func doRequest(completion: ((_ success: Bool, _ error: Error?)->())?)
//    {
//        self.makeRequest(method: .get, path: APIConstants.Paths.Cities.string) {
//            (request, response, statusCode, error) in
//            guard let completion = completion else { return }
//
//            if let error = error {
//                completion(false, error)
//            }else{
//                completion(true, nil)
//            }
//        }
//    }
    
}

