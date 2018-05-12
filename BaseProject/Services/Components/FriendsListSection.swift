//
//  FriendsListSection.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class FriendsListSection: TableViewServiceSection
{
    var friends: [Friend]
    
    init(friends: [Friend])
    {
        self.friends = friends
        super.init()
        self.items = self.items()
    }
    
    fileprivate func items() -> [TableViewServiceSectionItem]
    {
        var items = [TableViewServiceSectionItem]()

        if self.friends.count > 0 {
            items = self.friends.map({FriendItem(friend: $0) })
        }
        return items
    }
    
    override func defaultRouterForRow(_ row: Int) -> Routable?
    {
//        if let restaurant = self.restaurants[safe: row] {
//            return RestaurantRouter(action: RestaurantAction.details(restaurant: restaurant, address: self.address, historyOrder: nil, modally: false))
//        }
        return nil
    }
    
    func loadItems()
    {
        self.items = self.items()
    }
    
    func reloadItems()
    {
        self.items = self.items()
        self.delegate?.reloadSection(self)
    }
    
}

class FriendItem: TableViewServiceSectionItem
{
    var friend: Friend
    
    init(friend: Friend)
    {
        self.friend = friend
        super.init()
        self.nibName = "FriendTableViewCell"
        self.reuseIdentifier = "FriendTableViewCell"
    }
    
    override func setupCell(_ cell: UITableViewCell)
    {
        if let cell = cell as? FriendTableViewCell {
            cell.setup(self.friend)
        }
    }
}
