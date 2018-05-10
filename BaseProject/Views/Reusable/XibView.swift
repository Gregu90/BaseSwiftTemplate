//
//  XibView.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class XibView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.loadNib()
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
        self.setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.loadNib()
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
        self.setup()
    }
    
    fileprivate func loadNib()
    {
        let classHierarhy = NSStringFromClass(type(of: self)).split { $0 == "."}.map { String($0) }
        let className = classHierarhy.last
        Bundle.main.loadNibNamed(className!, owner: self, options: nil)
    }
    
    internal func setup()
    {
        
    }
    
}
