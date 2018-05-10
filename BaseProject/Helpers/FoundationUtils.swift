//
//  FoundationUtils.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

extension Array
{
    subscript (safe index: Int) -> Element?
    {
        return indices ~= index ? self[index] : nil
    }
}


extension Array where Element: Equatable
{
    mutating func removeElement(_ element : Iterator.Element)
    {
        if let index = self.index(of: element) {
            self.remove(at: index)
        }
    }
}

extension Array where Element: Hashable
{
    var uniqueElements: [Element] {
        return Array(Set(self))
    }
}

extension Dictionary
{
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    mutating func prepend(_ string: String)
    {
        self = string + self
    }
}

