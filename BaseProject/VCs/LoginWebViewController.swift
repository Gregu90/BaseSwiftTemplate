//
//  LoginWebViewController.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import WebKit
protocol LoginViewControllerDelegate {
    func codeToken(_ code: String)
}
class LoginWebViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    var delegate: LoginViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        self.webView.scrollView.maximumZoomScale = 0.0
        self.webView.isMultipleTouchEnabled = false
        var components = URLComponents(string: "https://auth.gog.com")!
        components.path = "/auth"
        components.queryItems = [URLQueryItem(name: "client_id", value: APIConstants.LoginConfig.client_id.string),
                                 URLQueryItem(name: "redirect_uri", value: "https://localhost/"/*"https%3A%2F%2Flocalhost%2F"*/),
                                 URLQueryItem(name: "response_type", value: "code"),
                                 URLQueryItem(name: "layout", value: "client2")]

        if let url = components.url {
            print(url)
                let myRequest = URLRequest(url: url)
                self.webView.load(myRequest)

        }
//        let addressString = "https://auth.gog.com/auth?client_id=" + APIConstants.LoginConfig.client_id.string + "&redirect_uri=" + APIConstants.LoginConfig.redirect_url.string + "&response_type=code&layout=client2"
//        let encoded = addressString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//
//            let myURL = URL(string: encoded!)
//        DLog("\(encoded)")
//            let myRequest = URLRequest(url: myURL!)
//            self.webView.load(myRequest)
        
        
//        let myURL = URL(string: "https://auth.gog.com/auth?client_id=" + APIConstants.LoginConfig.client_id.string + "&redirect_uri=" + APIConstants.LoginConfig.redirect_url.string + "&response_type=code&layout=client2".absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
//        let myRequest = URLRequest(url: myURL!)
//        self.webView.load(myRequest)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
        if(navigationAction.navigationType == .formSubmitted)
        {
            if navigationAction.request.url != nil
            {
                if let components: [String] = navigationAction.request.url?.absoluteString.components(separatedBy: "code=") {
                    if components.count == 2 {
                        if let code = components.last {
                            self.delegate?.codeToken(code)
                            navigationController?.popViewController(animated: true)
                            
                            dismiss(animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
        decisionHandler(.allow)
    }
    

    

}
