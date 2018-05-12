//
//  Router.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

enum Action: RoutableAction
{
    case webview(delegate: LoginViewControllerDelegate)
    case tabbarview()
    
    var vcIdentifier: String? {
        switch self {
        case .webview(_): return "LoginWebViewController"
        case .tabbarview(_): return "TabBarViewController"
        }
    }
    
    func configured() -> UIViewController? {
        guard let vc = self.vc else {return nil}
        switch self {
        case .webview(let delegate):
            let vca = (vc as! LoginWebViewController)
            vca.delegate = delegate
            return UINavigationController(rootViewController: vca)
        case .tabbarview():
            let vca = (vc as! TabBarViewController)
            return UINavigationController(rootViewController: vca)
        default: break
        }
        return vc
    }
    
    var presentationStyle: RoutablePresentationStyle {
        switch  self {
        case .webview(_): return .modal
        case .tabbarview(): return .popover
        }
    }
}

class Router: Routable
{
    var action: Action
    
    init(action: Action)
    {
        self.action = action
    }
    
    var vc: UIViewController? {
        return self.action.configured()
    }
    
    func routableAction() -> RoutableAction
    {
        return self.action
    }
}
