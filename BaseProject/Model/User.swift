//
//  User.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserToken
{
    var token: String?
    let id: String
    var refreshToken: String?
    var sessionId: String?
    var code: String?
    
}

extension UserToken: Mappable
{
        init?(map: Map)
        {
            guard let id: String = try? map.value(MappingKeys.id) else {
                DLog(MappingKeys.error)
                return nil
            }
            self.id = id
        }
    
        private struct MappingKeys
        {
            static let id = "user_id"
            static let token = "access_token"
            static let refreshToken = "refresh_token"
            static let sessionId = "session_id"
            static let error = "User Mapping Error"
        }
    
        mutating func mapping(map: Map)
        {
            id >>> map[MappingKeys.id]
            token <- map[MappingKeys.token]
            refreshToken <- map[MappingKeys.refreshToken]
            sessionId <- map[MappingKeys.sessionId]
        }
}

//struct User
//{
//    let id: Int
//    var email: String?
//    var firstName: String?
//}
//
//extension User: Mappable
//{
//    init?(map: Map)
//    {
//        guard let id: Int = try? map.value(MappingKeys.id) else {
//            DLog(MappingKeys.error)
//            return nil
//        }
//        self.id = id
//    }
//    
//    private struct MappingKeys
//    {
//        static let id = "id"
//        static let email = "email"
//        static let firstName = "first_name"
//        static let error = "User Mapping Error"
//    }
//    
//    mutating func mapping(map: Map)
//    {
//        id >>> map[MappingKeys.id]
//        email <- map[MappingKeys.email]
//        firstName <- map[MappingKeys.firstName]
//    }
//}
