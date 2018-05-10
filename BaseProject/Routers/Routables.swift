//
//  Routables.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol RoutableAction
{
    var vcIdentifier: String? {get}
    var presentationStyle: RoutablePresentationStyle {get}
}

protocol Routable
{
    var vc: UIViewController? {get}
    func routableAction()->RoutableAction
}

extension RoutableAction
{
    var vc :UIViewController? {
        if let vcIdentifier = self.vcIdentifier {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier)
            return vc
        }else{
            return nil
        }
    }
}

enum RoutablePresentationStyle
{
    case show
    case modal
    case popover
    case none
}

extension UIViewController
{
    func presentRoutable(_ routable: Routable)
    {
        if let vc = routable.vc {
            switch routable.routableAction().presentationStyle {
            case .show:
                self.navigationController?.pushViewController(vc, animated: true)
            case .modal:
                self.present(vc, animated: true, completion: nil)
            case .popover:
                var presenter: UIViewController? = nil
                if let tabVC = self.tabBarController {
                    presenter = tabVC
                }else if let navVC = self.navigationController {
                    presenter = navVC
                }else{
                    presenter = self
                }
                presenter!.present(vc, animated: false, completion: nil)
            case .none: break;
            }
        }
        
    }
    
    func tableViewService(showLoader service: TableViewService, type: AlertView.SpinnerType)
    {
        self.showLoaderView(type: type)
    }
    
    func tableViewService(removeLoader service: TableViewService, errorMessage: String?)
    {
        self.removeLoaderView()
        if let errorMessage = errorMessage {
            self.showErrorAlert(errorMessage)
        }
    }
    
    func tableViewService(showAlert message:String?, buttons: [String]?, handler: AlertView.AlertHandler?)
    {
        self.removeLoaderView()
        self.showAlertView(message, buttons: buttons, handler: handler)
    }
}
