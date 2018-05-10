//
//  AlertView.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit



class AlertView: UIView {
    
    enum AlertType {
        case loader
        case popup
        case poll
    }
    
    typealias AlertHandler = (_ buttonIndex: Int) -> ()
    
    var type: AlertType = .popup
    private var popupView: PopupView?
    private var popupViewYConstraint: NSLayoutConstraint?
    
    private var handler: AlertHandler? = nil
    private var pressedIndex = 0
    
    convenience init(view: UIView)
    {
        self.init(frame: view.frame)
        self.baseSetup()
    }
    
    private func baseSetup()
    {
        self.blendBackground()
    }
    
    private func blendBackground()
    {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    private func unblendBackground()
    {
        self.backgroundColor = UIColor.clear
    }
    
    
    class func loader(_ view: UIView, withType spinnerType: SpinnerType = .default) -> AlertView
    {
        let alert = AlertView(view: view)
        alert.type = .loader
        alert.accessibilityIdentifier = "loaderView"
        let spinner = AlertView.spinnerView(withType: spinnerType)
        
        spinner.center = alert.center
        
        alert.addSubview(spinner)
        return alert
    }
    
    class func popup(_ view: UIView, message: String?, buttons: [String]?, handler: AlertView.AlertHandler?) -> AlertView
    {
        let alert = AlertView(view: view)
        alert.handler = handler
        alert.popupView = PopupView(message: message, buttons: buttons, handler: {
            [weak alert](buttonIndex) in
            alert?.pressedIndex = buttonIndex
            alert?.hide()
        })
        
        
        alert.addSubview(alert.popupView!)
        
        let xConstraint = NSLayoutConstraint(item: alert.popupView!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: alert, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        alert.addConstraint(xConstraint)
        
        alert.popupViewYConstraint = NSLayoutConstraint(item: alert.popupView!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: alert, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        alert.addConstraint(alert.popupViewYConstraint!)
        
        return alert
    }
    
    
    func show()
    {
        if let popup = self.popupView{
            self.showPopup(popup)
        }
    }
    
    @objc func hide()
    {
        if let popup = self.popupView {
            self.hidePopup(popup)
        }else{
            self.postHideAction()
        }
        
    }
    
    let kAnimationTime :Double = 0.5
    let kAnimationDamping :CGFloat = 0.5
    let kAnimationSpringVelocity :CGFloat = 0.5
    
    private func showPopup(_ popupView: XibView)
    {
        let beginY = (self.frame.size.height/2 + popupView.frame.size.height/2 ) * -1
        self.popupViewYConstraint?.constant = beginY
        self.layoutIfNeeded()
        
        
        self.popupViewYConstraint?.constant = 0
        UIView.animate(withDuration: kAnimationTime, delay: 0, usingSpringWithDamping: kAnimationDamping, initialSpringVelocity: kAnimationSpringVelocity, options: UIViewAnimationOptions.curveEaseIn, animations:
            { () -> Void in
                self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hidePopup(_ popupView: XibView)
    {
        let middleY = popupView.frame.size.height * -0.25
        let endY: CGFloat = self.frame.size.height/2 + popupView.frame.size.height
        
        self.popupViewYConstraint?.constant = middleY
        UIView.animate(withDuration: kAnimationTime/4, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            self.popupViewYConstraint?.constant = endY
            UIView.animate(withDuration: self.kAnimationTime/2, animations: { () -> Void in
                self.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                self.postHideAction()
            })
        })
    }
    
    func postHideAction()
    {
        self.handler?(self.pressedIndex)
        self.removeFromSuperview()
    }
    
    enum SpinnerType {
        case `default`
        case cart
        
        fileprivate var animationTime: Double {
            switch self {
            case .default: return 0.5
            case .cart: return 0.5
            }
        }
        
        fileprivate var imagesRange: CountableClosedRange<Int> {
            switch self {
            case .default: return 1...8
            case .cart: return 1...8
            }
        }
        
        fileprivate var imageNamePrefix: String {
            switch self {
            case .default: return "pan_loader_"
            case .cart: return "cart_loader_"
            }
        }
        
        fileprivate var imageNames: [String] {
            return self.imagesRange.map({ "\(self.imageNamePrefix)\($0)"})
        }
    }
    
    private class func spinnerView(withType type: SpinnerType = .default) -> UIImageView
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.animationImages = type.imageNames.map({ UIImage(named: $0)! })
        imageView.animationDuration = type.animationTime
        imageView.startAnimating()
        return imageView
    }
    
}
