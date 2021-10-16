//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Aramis on 10/15/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var composeTweetTextView: UITextView!
    
    
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let errorColor = UIColor(red: 201.0/255.0, green: 44.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    let creamTextColor = UIColor(red: 230.0/255.0, green: 243.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeTweetTextView.delegate = self
        composeTweetTextView.becomeFirstResponder()
        stylisticChoices()
    }
    
    
    func stylisticChoices() {
        wrapperView.layer.cornerRadius = 25
        composeTweetTextView.layer.cornerRadius = 5
        publishButton.titleLabel?.textAlignment = .left
        publishButton.contentHorizontalAlignment = .left
        if #available(iOS 15.0, *) {
            publishButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            cancelButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        } else {
            publishButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
        characterLimitLabel.text = "0/240"
        characterLimitLabel.textColor = creamTextColor
        
        errorLabel.text = ""
        errorLabel.textColor = errorColor
        errorLabel.isHidden = true
    }
    
    
    func publishTweet() {
        guard let text = composeTweetTextView.text, !text.isEmpty else {return}
        
        let postRequestURLString: String = "https://api.twitter.com/1.1/statuses/update.json"
        
        let client = TwitterAPICaller.client
        let params: [String: Any] = [
            "status": text,
        ]
        
        client?.postRequest(url: postRequestURLString, parameters: params, success: {
            self.exit()
        }, failure: { [errorLabel] _ in
            guard let errorLabel = errorLabel else {return}
            errorLabel.text = "Failed to publish the tweet. Plesae try again later"
            errorLabel.isHidden = false
        })
    }
    
    
    func exit() {
        composeTweetTextView.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: Button Action handlers
    @IBAction func publishAction(_ sender: Any) {
        publishTweet()
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        exit()
    }

}


// MARK: Extension - UITextViewDelegate
extension ComposeTweetViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let textLen = textView.text.count
        characterLimitLabel.text = "\(textLen)/240"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        errorLabel.isHidden = true
        let newCharCount: Int = textView.text.count - range.length + text.count
        let shouldReplace = newCharCount <= 240
        if !shouldReplace {
            characterLimitLabel.textColor = errorColor
        } else {
            characterLimitLabel.textColor = creamTextColor
        }
        return shouldReplace
    }
}
