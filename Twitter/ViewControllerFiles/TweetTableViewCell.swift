//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Aramis on 10/8/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweetId: Int?
    
    var hasLiked: Bool = false {
        didSet {
            if hasLiked {
                likeButton.imageView?.image = UIImage(named: "favor-icon-red")!
            } else {
                likeButton.imageView?.image = UIImage(named: "favor-icon")!
            }
        }
    }
    var hasRetweeted: Bool = false {
        didSet {
            if hasRetweeted {
                retweetButton.imageView?.image = UIImage(named: "retweet-icon-green")!
            } else {
                retweetButton.imageView?.image = UIImage(named: "retweet-icon")!
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func bindButtons() {
//        likeButton.addTarget(self, action: #selector(likeButtonTarget), for: .touchUpInside)
//        retweetButton.addTarget(self, action: #selector(retweetButtonTarget), for: .touchUpInside)
    }
    
    
    func retweetTweet() {
        // Handles both retweet and unretweet
        guard let tweetId = tweetId else {return}
        let postRequestURLString: String = {
            if self.hasRetweeted {
                return "https://api.twitter.com/1.1/statuses/unretweet/\(tweetId).json"
            } else {
                return "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
            }
        }()
        
        let client = TwitterAPICaller.client
        let params: [String: Any] = [:]
//            "id": tweetId,
//        ]
        
        let newButtonState = !hasRetweeted
        
        client?.postRequest(url: postRequestURLString, parameters: params, success: {
            self.hasRetweeted = !self.hasRetweeted
            self.retweetButton.isEnabled = newButtonState
            print("retweet success called")
        }, failure: {error in
            print(error)
            self.retweetButton.isEnabled = !newButtonState
        })
    }
    
    func likeTweet() {
        // Handles both liking and unliking
        guard let tweetId = tweetId else {return}
        let postRequestURLString: String = {
            if self.hasLiked {
                return "https://api.twitter.com/1.1/favorites/destroy.json"
            } else {
                return "https://api.twitter.com/1.1/favorites/create.json"
            }
        }()
        
        let client = TwitterAPICaller.client
        let params: [String: Any] = [
            "id": tweetId,
        ]
        let newButtonState = !hasLiked
        
        print(tweetId)
        
        client?.postRequest(url: postRequestURLString, parameters: params, success: {
            self.hasLiked = !self.hasLiked
            self.likeButton.isEnabled = newButtonState
        }, failure: {error in
            self.likeButton.isEnabled = !newButtonState
            print(error)
        })
    }
    
    
    @IBAction func retweetButtonTarget(_ sender: UIButton?) {
        retweetTweet()
    }
    
    @IBAction func likeButtonTarget(_ sender: UIButton?) {
        likeTweet()
    }

}
