//
//  AuthenticatedViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/14/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit

class AuthenticatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onUnAuthenticatedRequest),
                                               name: NSNotification.Name(rawValue: "UnAuthenticated"),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func onUnAuthenticatedRequest(notification: Notification, sender: Any?) -> Void {
        self.pushToLogin()
    }
    
    func pushToLogin() -> Void {
        let welcomeVC = UIStoryboard(name: "WelcomeStoryboard", bundle: nil).instantiateInitialViewController()
        
        self.present(welcomeVC!, animated: true, completion: nil)
    }
}
