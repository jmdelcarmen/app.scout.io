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

class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTextField.delegate = self
        self.emailTextField.becomeFirstResponder()
    }

    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignupPressed(_ sender: UIButton) {
        let email = self.emailTextField.text!
        let username = self.usernameTextField.text!
        let passoword = self.passwordTextField.text!
        
        SVProgressHUD.show()
        ScoutRequest().signup(username: username, email: email, password: passoword) { (error, response) in
            SVProgressHUD.dismiss()

            if error == nil {
                ScoutRequest.storeJWT(response!["data"].stringValue)
                self.onUserAuthenticated()
            } else {
                SVProgressHUD.showError(withStatus: "Request failed. Username or Email may be already taken")
            }
        }
    }
    
    func onUserAuthenticated() -> Void {
        let homeStoryBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let homeVC = homeStoryBoard.instantiateInitialViewController()!
        
        present(homeVC, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.onSignupPressed(self.signupButton)
        
        return true
    }
}
