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
    }
    
    fileprivate func items() -> [TableViewServiceSectionItem]
    {
        var items = [TableViewServiceSectionItem]()
        
        if self.restaurants.count > 0 {
            items = self.friends.map({ (r) -> TableViewServiceSectionItem in
                RestaurantItem(restaurant: r) })
        } else {
            if isActiveSearch {
                items.append(NoContentsItem(text: "restaurantList.searchedRestaurant.emptyList.message".localized))
            }else{
                items.append(NoContentsItem(text: "restaurantList.emptyList.message".localized))
            }
        }
        return items
    }
    
    override func defaultRouterForRow(_ row: Int) -> Routable?
    {
        if let restaurant = self.restaurants[safe: row] {
            return RestaurantRouter(action: RestaurantAction.details(restaurant: restaurant, address: self.address, historyOrder: nil, modally: false))
        }
        return nil
    }
    
}

class FriendItem: TableViewServiceSectionItem
{
    var friend: Friend
    
    init(friend: Friend)
    {
        self.friend = friend
        super.init()
        self.nibName = "RestaurantTableViewCell"
        self.reuseIdentifier = "RestaurantTableViewCell"
    }
    
    override func setupCell(_ cell: UITableViewCell)
    {
        if let cell = cell as? RestaurantTableViewCell {
            cell.setup(self.restaurant)
        }
    }
}
