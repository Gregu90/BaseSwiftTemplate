//
//  ViewControllerExtensions.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIViewController
{
    var isOnScreen: Bool {
        return self.viewIfLoaded != nil && self.view.window != nil
    }
    
    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    var isFirstInStack: Bool {
        return (self.navigationController == nil || self.navigationController?.viewControllers.first == self)
    }
    
    func setEmptyBackButton()
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    var shouldShowCloseButton: Bool {
        return self.isModal && self.isFirstInStack
    }
    
    
    struct Constants {
        static let closeFromCloseButtonSelectorName = "closeFromCloseButton"
        static let closeFromBackButtonSelectorName = "closeFromBackButton"
    }
    
    
    func addCloseButtonIfNeeded(_ title: String? = nil, left: Bool = true)
    {
//        if self.shouldShowCloseButton {
//            let barButton: UIBarButtonItem
//            if let title = title {
//                barButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: Selector(UIViewController.Constants.closeFromCloseButtonSelectorName))
//            }else{
//                barButton = UIBarButtonItem(image: AppImage.closeIcon.image, style: .plain, target: self, action: Selector(UIViewController.Constants.closeFromCloseButtonSelectorName))
//            }
//            if left {
//                self.navigationItem.leftBarButtonItem = barButton
//            }else {
//                self.navigationItem.rightBarButtonItem = barButton
//            }
//        }
    }
    
    @objc func closeFromCloseButton()
    {
        let controller = self.navigationController?.presentingViewController ?? self.presentingViewController
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func closeFromBackButton()
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func closeFromBackOrCloseButton()
    {
        if self.shouldShowCloseButton {
            self.closeFromCloseButton()
        } else {
            self.closeFromBackButton()
        }
    }
    
    class func topViewController(_ rootViewController: UIViewController?) -> UIViewController?
    {
        if let navigationController = rootViewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }else if let tabbarController = rootViewController as? UITabBarController {
            if let selectedViewController = tabbarController.selectedViewController {
                return topViewController(selectedViewController)
            }
        }else if let presentedViewController = rootViewController?.presentedViewController {
            return topViewController(presentedViewController)
        }
        return rootViewController
    }
    
    override open func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
        }
    }
}
