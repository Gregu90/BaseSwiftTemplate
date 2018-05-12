//
//  APIConstants.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

protocol StringConvertible
{
    var string: String {get}
}

extension RawRepresentable where RawValue == String
{
    var string: String
    {
        return self.rawValue
    }
}

struct APIConstants
{
    
    enum Paths: StringConvertible
    {
        case token
        case friends(userId: String)
        
        var string: String
        {
            switch self {
            case .token: return
                "token"
            case .friends(let userId): return
                "users/\(userId)/friends"
            
            }
        }
    }
    
    enum AuthHeaderKeys: String
    {
        case apiKey = "X-API-KEY"
        case apiHash = "X-API-HASH"
    }

    enum LoginConfig: String
    {
        case client_id = "51205051179528065"
        case client_secret = "55de1a613d7e405578d4bd11fb58ff517ce03fb519373e3a04e3c3642c5487ff"
        case redirect_url = "https://localhost/"

    }
    
}
