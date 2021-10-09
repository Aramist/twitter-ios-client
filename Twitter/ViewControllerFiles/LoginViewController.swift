//
//  LoginViewController.swift
//  Twitter
//
//  Created by Aramis on 10/8/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.stylisticDetails()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let loggedIn = defaults.bool(forKey: "UserLoggedIn")
        if loggedIn {
            self.performSegue(withIdentifier: "exitLoginSegue", sender: self)
        }
    }
    
    func stylisticDetails() {
        self.loginButton.layer.cornerRadius = 10
        self.logoImage.layer.cornerRadius = 10
        
        self.errorLabel.textColor = Colors.errorColor
        self.errorLabel.isHidden = true
    }

    
    func performLogin() {
        self.errorLabel.isHidden = true
        let apiClient = TwitterAPICaller.client
        let reqURL = "https://api.twitter.com/oauth/request_token"
        
        apiClient?.login(url: reqURL, success: {
            self.performSegue(withIdentifier: "exitLoginSegue", sender: self.loginButton)
            // Set login flag
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "UserLoggedIn")
            defaults.synchronize()
        }, failure: {(Error) in
            self.presentErrorMessage()
        })
    }
    
    func presentErrorMessage() {
        self.errorLabel.isHidden = false
    }
    
    @IBAction func buttonHandler(_ sender: Any) {
        self.performLogin()
    }
    
}
