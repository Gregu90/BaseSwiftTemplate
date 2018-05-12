//
//  UserService.swift
//  BaseProject
//
//  Created by Admin on 11.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UserService
{
    typealias UserOperationCompletion = (_ success: Bool, _ error: Error?)->()
    
    fileprivate let apiClient: APIClient
    fileprivate var userAuthData: UserToken?
    var friends: [Friend] = []
    
    init(apiClient: APIClient)
    {
        self.apiClient = apiClient
    }
    
    func getToken(_ code: String, completion: @escaping UserOperationCompletion)
    {
        self.apiClient.getToken(code) {
            [weak self](user, error) in
            guard let sself = self else { return }
            if let user = user {
                Settings.currentUser = user
                sself.userAuthData = user
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func refreshToken(completion: @escaping UserOperationCompletion)
    {
        if let user = Settings.currentUser {
            self.apiClient.refreshToken(user) {
                [weak self](user, error) in
                guard let sself = self else { return }
                if let user = user {
                    Settings.currentUser = user
                    sself.userAuthData = user
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        } else {
            completion(false, nil)
        }
        
    }
    
    func getFriends(completion: @escaping UserOperationCompletion)
    {
        if let user = userAuthData {
            self.apiClient.getFriends(userId: user.id) {
                [weak self](friends, error) in
                guard let sself = self else { return }
                if let error = error {
                    completion(false, error)
                } else {
                    sself.friends = friends
                    completion(true, nil)
                }
            }
        } else {
            completion(false, nil)
        }
        
    }

    
    
}
