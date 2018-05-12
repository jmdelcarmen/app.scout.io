//
//  YelpWebViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/11/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

protocol YelpWebViewControllerDelegate {
}

class YelpWebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    var delegate: YelpWebViewControllerDelegate?
    var yelpId: String? {
        didSet {
            DispatchQueue.main.async {
                if self.canOpenURLWithYelp() {
                    self.openURLWithYelp()
                } else {
                    self.openURLWithWebView()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        SVProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    func canOpenURLWithYelp() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "yelp4:///biz/\(self.yelpId!)")!)
    }
    
    func openURLWithYelp() -> Void {
        UIApplication.shared.open(URL(string: "yelp4:///biz/\(self.yelpId!)")!, options: [:], completionHandler: nil)
    }
    
    func openURLWithWebView() -> Void {
        SVProgressHUD.show()
        let request = URLRequest(url: URL(string: "https://yelp.com/biz/\(self.yelpId!)")!)
        self.webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
