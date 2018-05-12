//
//  Friend.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

struct Friend
{
    var name: String?
    let id: String
    var isEmployee: Bool = false
    var smallImageUrl: String?
    var largeImageUrl: String?
    var status: OnlineStatus = .hidden
}

extension Friend: Mappable
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
        static let name = "username"
        static let isEmployee = "is_employee"
        static let smallImageUrl = "images.medium"
        static let largeImageUrl = "medium.medium_2x"
        static let status = "room.status"
        static let error = "Friend Mapping Error"
    }
    
    mutating func mapping(map: Map)
    {
        id >>> map[MappingKeys.id]
        name <- map[MappingKeys.name]
        isEmployee <- map[MappingKeys.isEmployee]
        smallImageUrl <- map[MappingKeys.smallImageUrl]
        largeImageUrl <- map[MappingKeys.largeImageUrl]
        status <- map[MappingKeys.status]
    }
}

enum OnlineStatus: String {
    case hidden = "hidden"
    case online = "visible"
}

struct FriendList
{
    var items: [Friend] = []
}
extension FriendList: Mappable
{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
        items <- map["items"]
    }
}
