//
//  Game.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ObjectMapper

struct Game {
    var embedded: Embedded?
    var description: String = ""
}

extension Game: Mappable
{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
//        id <- map["_embedded.product.id"]
//        title <- map["_embedded.product.name"]
//        imageUrl <- map["_embedded.product.image.href"]
//        formatters <- map["_embedded.product.image.formatters"]
        description <- map["description"]
//        self.imageFixer()
        embedded <- map["_embedded"]
    }
//
//    mutating func imageFixer() {
//        var newString = ""
//        if formatters.contains("glx_logo_2x") {
//            newString = self.imageUrl.replacingOccurrences(of: "{formatter}", with: "glx_logo_2x", options: .literal, range: nil)
//        } else if formatters.contains("800") {
//            newString = self.imageUrl.replacingOccurrences(of: "{formatter}", with: "800", options: .literal, range: nil)
//        }
//        self.imageUrl = newString
//    }
}

struct Embedded {
    var productInGame: ProductInGame?
}
extension Embedded: Mappable
{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
        productInGame <- map["product"]

    }
}

struct ProductInGame {
    var id: Int = 0
    var title: String = ""
    var imageUrl: String = ""
    var formatters: [String] = []
}

extension ProductInGame: Mappable
{
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
        id <- map["id"]
        title <- map["title"]
        imageUrl <- map["_links.image.href"]
        formatters <- map["_links.image.formatters"]
        self.imageFixer()
    }
    
    mutating func imageFixer() {
        var newString = ""
        if formatters.contains("glx_logo_2x") {
            newString = self.imageUrl.replacingOccurrences(of: "{formatter}", with: "glx_logo_2x", options: .literal, range: nil)
        } else if formatters.contains("800") {
            newString = self.imageUrl.replacingOccurrences(of: "{formatter}", with: "800", options: .literal, range: nil)
        }
        self.imageUrl = newString
    }
}
