//
//  LoginViewController.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewControllerDelegate {

    @IBOutlet weak var loginButton: RoundedButton!
    
    var userService: UserService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userService = UserService(apiClient: APIClient.sharedClient)
        self.loginButton.isHidden = true
        if Settings.currentUser != nil {
            self.userService.refreshToken {
                (success, error) in
                if success {
                    self.getFriendsAndMoveOn()
                } else {
                    self.loginButton.isHidden = false
                }
            }
            
        } else {
             self.loginButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {

        let action = Action.webview(delegate: self)
        let router = Router(action: action)
        self.presentRoutable(router)
        
    }
    
    func codeToken(_ code: String) {
        self.userService.getToken(code) {
            (success, error) in
            if success {
                self.getFriendsAndMoveOn()
            } else {
               self.showErrorAlert("niema tokenu")
            }
        }
    }
    
    func getFriendsAndMoveOn() {
        self.userService.getFriends {
            (success, error) in
            if success {
                self.getLibraryAndMoveOn()
            } else {
                self.showErrorAlert("friends error")
            }
        }
    }
    
    func getLibraryAndMoveOn() {
        self.userService.getLibrary {
            (success, error) in
            if success {
                
                
                self.getAllLibraryAndMoveOn()
            } else {
                self.showErrorAlert("friends error")
            }
        }
    }
    
    func getAllLibraryAndMoveOn() {
        self.userService.getAllGames {
            (success, error) in
            if success {
                
                
                let action = Action.tabbarview()
                let router = Router(action: action)
                self.presentRoutable(router)
            } else {
                self.showErrorAlert("friends error")
            }
        }
    }
}
