//
//  SignupViewController.swift
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

class SignupViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignupPressed(_ sender: UIButton) {
        let email = self.emailTextField.text!
        let username = self.usernameTextField.text!
        let passoword = self.passwordTextField.text!
        
        self.signup(withUserNameAndEmail: username, email: email, password: passoword) { (error: Any?, data: JSON?) in

            if error == nil, data?["success"] == true {
                let token = data!["data"].stringValue
                self.storeJWT(token)
                self.onUserAuthenticated()
            } else if (error != nil) {
                SVProgressHUD.showError(withStatus: "Request failed")
            } else {
                SVProgressHUD.showError(withStatus: "Username or Email is already taken")
            }
        }
    }
    
    func onUserAuthenticated() -> Void {
        let homeStoryBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let homeVC = homeStoryBoard.instantiateInitialViewController()!
        
        present(homeVC, animated: true, completion: nil)
    }

    func storeJWT(_ token: String) -> Void {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let keychain = Keychain(service: bundleIdentifier)
        
        keychain["token"] = token
    }
    
    func signup(withUserNameAndEmail username: String, email: String, password: String, _ cb: @escaping (_ error: Any?, _ response: JSON?) -> Void) -> Void {
        let params: [String: String] = ["username": username, "email": email, "password": password]
        SVProgressHUD.show()

        Alamofire.request("http://localhost:3000/auth/signup", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            SVProgressHUD.dismiss()
            if response.result.isSuccess, let data = response.data {
                cb(nil, JSON(data))
            } else {
                cb(response.error, nil)
            }
        }
    }
}
