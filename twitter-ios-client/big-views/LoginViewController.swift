//
//  ViewController.swift
//  twitter-ios-client
//
//  Created by Aramis on 10/2/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginBox: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // Referenced for the sake of hiding/showing error messages
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelConfiningView: UIView!
    
    
    var authToken: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artisticTouches()
    }
    
    
    func artisticTouches() {
        self.view.backgroundColor = Colors.whiteColor
        self.loginBox.backgroundColor = Colors.blueColor
        self.loginBox.layer.cornerRadius = 15.0
        
        self.errorLabel.textColor = Colors.errorColor
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.errorLabel.numberOfLines = 0
        self.errorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.hideErrorLabel()
        
        self.emailField.textColor = Colors.blackColor
        self.emailField.textContentType = .emailAddress
        self.passwordField.textColor = Colors.blackColor
        self.passwordField.textContentType = .password
        self.passwordField.isSecureTextEntry = true
        
        var config = UIButton.Configuration.plain().updated(for: self.submitButton)
        config.title = "Login"
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        config.baseForegroundColor = Colors.whiteColor
        self.submitButton.configuration = config
    }
    
    
    func handleLogin() {
        // TODO: For now just print email and password to verify they are there
        
        // Start by hiding the error label, just in case there were old errors being displayed
        self.hideErrorLabel()
        
        let email = self.emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = self.passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        
        // Some simple verification
        if email == "" && password == "" {
            self.presentError("Please enter your credentials to continue.")
            return
        } else if password == "" {
            self.presentError("Please enter a valid password")
            return
        } else if !validateEmail(email) {
            self.presentError("Please enter a valid email address")
            return
        }

        let apiClient = TwitterAPICaller.client
        let reqURL = "https://api.twitter.com/oauth/request_token"
//        apiClient?.login(url: reqURL, success: {
        self.performSegue(withIdentifier: "loginToHomepage", sender: self)
//        }, failure: { (Error) in
//            self.presentError("Failed to login with given email and password.")
//        })
    }
    
    
    func presentError(_ message: String) {
        self.errorLabel.text = message
        self.showErrorLabel()
    }
    
    
    // Turning these into functions because there are two things to change
    func hideErrorLabel() {
        self.errorLabel.isHidden = true
        self.errorLabelConfiningView.isHidden = true
    }
    
    
    func showErrorLabel() {
        self.errorLabel.isHidden = false
        self.errorLabelConfiningView.isHidden = false
    }
    
    
    func validateEmail(_ email: String) -> Bool {
        /**
         Performs a simple, regex-based validation of the given email
         Uses a regex pattern from emailregex.com
         */
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    
    // MARK: Navigation
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        // Always disallow user-prompted segue from login to homepage
//        // It will be initiated programmatically when the credentials are verified
//        if identifier == "loginToHomepage"{
//            return false;
//        }
//        return true;
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // TODO: send data
//        if segue.identifier == "loginToHomepage" {}
//    }
    
    // MARK: IB Extensions
    
    @IBAction func loginButtonHandler(_ sender: Any) {
        self.handleLogin()
    }
}

