//
//  TableViewServiceSectionBuilder.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct TableViewServiceSectionBuilder
{
    static func sectionWithItem(_ item: Any) -> TableViewServiceSection
    {
        switch item {
        case is TableViewServiceSection:
            return item as! TableViewServiceSection
        default:
            assertionFailure("SectionBuilder: \(item) unhandled")
            return TableViewServiceSection()
        }
    }
}
