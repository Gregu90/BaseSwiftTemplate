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
    case webview(title: String, url: URL)
    
    var vcIdentifier: String? {
        switch self {
        case .webview(_): return "WebViewController"
        }
    }
    
    func configured() -> UIViewController? {
        guard let vc = self.vc else {return nil}
        switch self {
//        case .webview(let title, let url):
//            let vca = (vc as! WebViewController)
//            vca.title = title
//            vca.url = url
//            return UINavigationController(rootViewController: vca)
        
        default: break
        }
        return vc
    }
    
    var presentationStyle: RoutablePresentationStyle {
        switch  self {
        case .webview(_): return .modal
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
