//
//  UIViewControllerAlertExtensions.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func viewForAlert() -> UIView
    {
        if let tabBarController = self.tabBarController {
            return tabBarController.view
        }else if let navbarController = self.navigationController {
            return navbarController.view
        }else{
            return self.view
        }
    }
    
    func showMissingFeatureAlert()
    {
        self.showErrorAlert("Feature not implemented yet.\n\nSorry, Developers")
    }
    
    func showErrorAlert(_ message: String?, buttons: [String]? = nil, tag: Int = 0, code:Int? = nil, handler: AlertView.AlertHandler? = nil)
    {
        self.showAlertView(message, buttons: buttons, tag: tag, handler: handler)
    }
    
    func showAlertView(_ message: String?, buttons: [String]? = nil, tag: Int = 0, handler: AlertView.AlertHandler? = nil)
    {
        let view = self.viewForAlert()
        let alert = AlertView.popup(view, message: message, buttons: buttons, handler: handler)
        alert.tag = tag
        view.addSubview(alert)
        alert.show()
    }
    
    func showLoaderView(type: AlertView.SpinnerType = .default)
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let view = self.viewForAlert()
        let alert = AlertView.loader(view, withType: type)
        view.addSubview(alert)
    }
    
    
    func removeLoaderView()
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let view = self.viewForAlert()
        for v in view.subviews {
            if let v = v as? AlertView {
                if v.type == .loader {
                    v.hide()
                    return
                }
            }
        }
    }
    
}
