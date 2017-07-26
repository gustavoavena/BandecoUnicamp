//
//  FeedbackViewController.swift
//  BandecoUnicamp
//
//  Created by Julianny Favinha on 7/24/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import WebKit

class FeedbackViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        // cria uma webview programaticamente
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // url do forms
        let myURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSekvO0HnnfGnk0-FLTX86mVxAOB5Uajq8MPmB0Sv1pXPuQiCg/viewform")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
