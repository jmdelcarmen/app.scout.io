//
//  LoginViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/10/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import KeychainAccess

class LoginViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var usernameOrEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameOrEmailTextField.becomeFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onLoginPressed(_ sender: UIButton) {
        let usernameOrEmail = self.usernameOrEmailTextField.text!
        let password = self.passwordTextField.text!
        
        SVProgressHUD.show()
        ScoutRequest().login(withUsernameOrEmail: usernameOrEmail, password: password) { (error, response) in
            SVProgressHUD.dismiss()
            if error == nil {
                let token = response!["data"].stringValue
                ScoutRequest.storeJWT(token)
                self.onUserAuthenticated()
            } else {
                SVProgressHUD.showError(withStatus: "Incorrect username or password")
            }
        }
    }
    
    func onUserAuthenticated() -> Void {
        let homeStoryBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let homeVC = homeStoryBoard.instantiateInitialViewController()!
        
        present(homeVC, animated: true, completion: nil)
    }
}
