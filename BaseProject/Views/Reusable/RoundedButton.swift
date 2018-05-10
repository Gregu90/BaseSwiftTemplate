//
//  RoundedButton.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    var cornerRadius: CGFloat = 4.0
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.cornerRadius
    }
    
    ///Ensure that your button is UIButtonType.Custom in order to have "nice" pressed state
    func setBackgroundColor(_ color: UIColor, forState state: UIControlState = UIControlState())
    {
        let coloredImage = UIImage(color: color)
        self.setBackgroundImage(coloredImage, for: state)
    }
    
}

