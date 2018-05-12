//
//  LibraryViewController.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    @IBOutlet weak var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [AppColor.gradientWhite.color.cgColor, AppColor.gradientDark.color.cgColor]
        
        gradientLayer.startPoint = CGPoint.init(x: 1.0, y: 1.0)
        gradientLayer.endPoint =  CGPoint.init(x: 0.0, y: 0.0)
        
        self.background.layer.addSublayer(gradientLayer)
        //self.view.layer.addSublayer(gradientLayer)
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
