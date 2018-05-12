//
//  LibraryViewController.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var background: UIView!
    var games: [Game] = APIClient.sharedClient.games
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        self.tableView.backgroundColor = UIColor.clear
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        
        cell.setup(game: self.games[indexPath.row])
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.games.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
}
