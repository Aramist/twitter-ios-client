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
    
    
    
    let blueColor = UIColor(red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    let whiteColor = UIColor(red: 230.0/255.0, green: 243.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    let blackColor = UIColor(red: 10.0/255.0, green: 9.0/255.0, blue: 12.0/255.0, alpha: 1.0)
    let errorColor = UIColor(red: 201.0/255.0, green: 44.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artisticTouches()
    }
    
    
    func artisticTouches() {
        self.view.backgroundColor = whiteColor
        self.loginBox.backgroundColor = blueColor
        self.loginBox.layer.cornerRadius = 15.0
        
        self.errorLabel.textColor = errorColor
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.errorLabel.numberOfLines = 0
        self.errorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.hideErrorLabel()
        
        self.emailField.textColor = blackColor
        self.emailField.textContentType = .emailAddress
        self.passwordField.textColor = blackColor
        self.passwordField.textContentType = .password
        self.passwordField.isSecureTextEntry = true
        
        var config = UIButton.Configuration.plain().updated(for: self.submitButton)
        config.title = "Login"
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        config.baseForegroundColor = whiteColor
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

        
        print(email)
        print(password)
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
    
    
    @IBAction func loginButtonHandler(_ sender: Any) {
        self.handleLogin()
    }
}

