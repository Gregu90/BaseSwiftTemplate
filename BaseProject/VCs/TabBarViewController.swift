//
//  TabBarViewController.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var friends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if let parent = parent as? ChatViewController {
            self.title = "Chat"
        } else if let parent = parent as? WishListViewController {
            self.title = "Wishlist"
        } else if let parent = parent as? LibraryViewController {
            self.title = "Biblioteka"
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        DLog("item name:\(tabBar)")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let parent = viewController as? ChatViewController {
            self.title = "Chat"
        } else if let parent = viewController as? WishListViewController {
            self.title = "Wishlist"
        } else if let parent = viewController as? LibraryViewController {
            self.title = "Biblioteka"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
