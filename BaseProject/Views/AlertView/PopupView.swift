//
//  PopupView.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PopupView: XibView {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var leftButton: RoundedButton!
    @IBOutlet var rightButton: RoundedButton!
    
    
    
    var buttonHandler: AlertView.AlertHandler?
    
    convenience init(message: String?, buttons: [String]?, handler: AlertView.AlertHandler?)
    {
        self.init(frame: CGRect.zero)
        self.messageLabel.text = message
        
        self.setupButtons(buttons)
        self.buttonHandler = handler
        
    }
    
    override func setup()
    {
        super.setup()
        self.setupColors()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setupColors()
    {
        let primaryColor = AppColor.lightText.color
        let secondaryColor = AppColor.secondary.color
        
        self.contentView.backgroundColor = primaryColor
        self.contentView.layer.cornerRadius = 8.0
        
        UIView.setTextColor(AppColor.darkText.color, forViews: [self.messageLabel])
        UIView.setTextColor(primaryColor, forViews: [self.leftButton, self.rightButton])
        
        self.leftButton.setBackgroundColor(secondaryColor)
        self.rightButton.setBackgroundColor(secondaryColor)
        
        self.rightButton.layer.borderWidth = 1.0
        self.rightButton.layer.borderColor = secondaryColor.cgColor
    }
    
    fileprivate func setupButtons(_ buttons: [String]?)
    {
        if let first = buttons?[safe: 0] {
            self.leftButton.setTitle(first.uppercased())
        }else{
            self.leftButton.setTitle("common.ok".localized.uppercased())
        }
        
        if let second = buttons?[safe: 1] {
            self.rightButton?.setTitle(second.uppercased())
        }else{
            self.buttonsStackView.removeArrangedSubview(self.rightButton)
            self.rightButton.removeFromSuperview()
        }
    }
    
    @IBAction fileprivate func buttonPressed(_ sender: UIButton)
    {
        buttonHandler?(sender.tag)
    }
    
}
