//
//  TableViewServiceSection.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol TableViewServiceSectionDelegate: class
{
    func routerTriggered(_ router: Routable, forSection section: TableViewServiceSection)
    func cell(forItemIndex itemIndex: Int, inSection section: TableViewServiceSection) -> UITableViewCell?
    func section(showLoader forSection:TableViewServiceSection, type: AlertView.SpinnerType)
    func section(removeLoader forSection: TableViewServiceSection, withErrorMessage message: String?)
    func reloadSection(_ section: TableViewServiceSection)
    func reloadSection(_ section: TableViewServiceSection, withAnimation animation: UITableViewRowAnimation)
    func reloadItems(_ items: [TableViewServiceSectionItem], forSection section: TableViewServiceSection)
    func scrollToCell(_ atIndexPath: IndexPath)
    func scrollTo(_ item: TableViewServiceSectionItem, inSection section: TableViewServiceSection)
    func showAlertWithButtons(_ message: String?, buttons: [String]?, handler: AlertView.AlertHandler?)
}

class TableViewServiceSection: TableViewServiceSectionItemDelegate
{
    class func sectionForItem(_ item: AnyObject) -> TableViewServiceSection!
    {
        return nil
    }
    var headerItem: TableViewServiceSectionItem? {
        return nil
    }
    var headerTitle: String? = nil
    var headerHeight: CGFloat = 30.0
    
    var items = [TableViewServiceSectionItem]()
    weak var delegate: TableViewServiceSectionDelegate?
    
    func section(cellForRow row: Int, forTableView tableView: UITableView) -> UITableViewCell
    {
        let item = self.items[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier)!
        item.setupCell(cell)
        return cell
    }
    
    func defaultRouterForRow(_ row: Int) -> Routable?
    {
        return self.items[row].defaultRouter
    }
    
    func estimatedRowHeight(_ row: Int) -> CGFloat
    {
        return self.items[row].estimatedRowHeight
    }
    
    func routerTriggered(_ router: Routable, forItem item: TableViewServiceSectionItem)
    {
        self.delegate?.routerTriggered(router, forSection: self)
    }
    
    func sectionItem(showLoader forSectionItem: TableViewServiceSectionItem, type: AlertView.SpinnerType) {
        self.delegate?.section(showLoader: self, type: type)
    }
    
    func sectionItem(removeLoader forSection: TableViewServiceSectionItem, withErrorMessage message: String?) {
        self.delegate?.section(removeLoader: self, withErrorMessage: message)
    }
    
    func modifyHeaderView(_ view: UITableViewHeaderFooterView)
    {
    }
    
    func scrollToCell(_ indexPath: IndexPath)
    {
        self.delegate?.scrollToCell(indexPath)
    }
    
    func showAlertWithButtons(_ message: String?, buttons: [String]?, handler: AlertView.AlertHandler?)
    {
        self.delegate?.showAlertWithButtons(message, buttons: buttons, handler: handler)
    }
}
