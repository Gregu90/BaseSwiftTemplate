//
//  Settings.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

struct Settings
{
    fileprivate static let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    fileprivate static let prefix = "GOGHackathon.app."
    
    fileprivate enum Keys: String
    {
        case currentUser = "currentUser"
        
        var key: String {
            return Settings.prefix + self.rawValue
        }
        
        static var all: [Keys] = [.currentUser]
    }

    
    static var currentUser: UserToken? {
        set {
            Settings.set(newValue, forKey: Keys.currentUser.key)
        }
        get {
            return Settings.get(valueForKey: Keys.currentUser.key)
        }
    }
    
    fileprivate static var defaults = UserDefaults.standard
}


import ObjectMapper
fileprivate extension Settings
{
    
    static func set<T: Mappable>(_ value: T?, forKey key: String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value?.toJSONString(), forKey: key)
    }
    
    static func get<T: Mappable>(valueForKey key: String) -> T?
    {
        let defaults = UserDefaults.standard
        if let string = defaults.string(forKey: key) {
            return Mapper<T>().map(JSONString: string)
        }else{
            return nil
        }
    }
}

import Locksmith
fileprivate extension Settings
{
    static func setSecure<T: Mappable>(_ value: T?, forKey key: String)
    {
        if let json = value?.toJSON() {
            try? Locksmith.updateData(data: json, forUserAccount: key)
        }else{
            try? Locksmith.deleteDataForUserAccount(userAccount: key)
        }
    }
    
    static func getSecure<T: Mappable>(valueForKey key: String) -> T?
    {
        if let data = Locksmith.loadDataForUserAccount(userAccount: key) {
            return Mapper<T>().map(JSON: data)
        }else{
            return nil
        }
    }
    
    static func deleteSecure(forKey key: String)
    {
        try? Locksmith.deleteDataForUserAccount(userAccount: key)
    }
}
