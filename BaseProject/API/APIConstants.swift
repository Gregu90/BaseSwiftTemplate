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
        case cities

        
        var string: String
        {
            switch self {
            case .cities: return
                "cities"
            
            }
        }
    }
    
    enum AuthHeaderKeys: String
    {
        case apiKey = "X-API-KEY"
        case apiHash = "X-API-HASH"
    }

}
