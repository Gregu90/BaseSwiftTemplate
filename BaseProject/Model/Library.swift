//
//  Library.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ObjectMapper

struct Library {
    var items: [Product] = []
}

extension Library: Mappable
{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
        items <- map["_embedded.items"]
    }
}

struct Product {
    var productId: Int = 0
}
extension Product: Mappable
{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
        productId <- map["productId"]
    }
}
