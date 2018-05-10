//
//  TableViewSectionItem.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol TableViewServiceSectionItemDelegate: class
{
    func routerTriggered(_ router: Routable, forItem item: TableViewServiceSectionItem)
    func sectionItem(showLoader forSectionItem:TableViewServiceSectionItem, type: AlertView.SpinnerType)
    func sectionItem(removeLoader forSection: TableViewServiceSectionItem, withErrorMessage message: String?)
}

class TableViewServiceSectionItem
{
    var nibName: String!
    var reuseIdentifier: String!
    func setupCell(_ cell: UITableViewCell){}
    weak var delegate: TableViewServiceSectionItemDelegate?
    var defaultRouter: Routable?
    
    var estimatedRowHeight: CGFloat {
        get{
            return 44.0
        }
    }
}
