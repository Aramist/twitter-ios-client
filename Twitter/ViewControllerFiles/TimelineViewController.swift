//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Aramis on 10/8/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tweetTable: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var tweetCache: [NSDictionary] = []
    static let MAX_TWEETS: Int = 60
    let numTweetsToFetch: Int = 20
    
    let refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTable.dataSource = self
        tweetTable.delegate = self
        
        getTweets()
        
        refreshControl.addTarget(self, action: #selector(reloadTweets), for: .valueChanged)
        tweetTable.refreshControl = self.refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        getTweets()
    }
    
    
    func getTweets(_ withParams: [String: Any]? = nil, wipeCache wipe: Bool = false) {
        let reqURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        var reqParams: [String: Any]
        if withParams != nil{
            reqParams = withParams!
        } else {
            reqParams = ["count": self.numTweetsToFetch]
        }
        let apiClient = TwitterAPICaller.client
        apiClient?.getDictionariesRequest(url: reqURL, parameters: reqParams, success: {(data) in
            if wipe {
                self.tweetCache.removeAll()
            }
            
            for tweet in data {
                self.tweetCache.append(tweet)
            }
            
            if self.tweetCache.count > TimelineViewController.MAX_TWEETS {
                let numToRemove = self.tweetCache.count - TimelineViewController.MAX_TWEETS
                self.tweetCache.removeSubrange(0..<numToRemove)
            }
            
            self.tweetTable.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: {(error) in
            print("Could not fetch tweets.")
        })
    }
    
    func loadAdditionalTweets() {
        let specialParams = [
            "count": tweetCache.count + self.numTweetsToFetch,
        ]
        
        getTweets(specialParams)
    }
    
    @objc func reloadTweets() {
        getTweets(nil, wipeCache: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "UserLoggedIn")
        defaults.synchronize()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetCache.count
    }
}


// MARK: DataSource Extension
extension TimelineViewController: UITableViewDataSource {
    
    func styleCell(_ cell: TweetTableViewCell) {
        cell.profileImage.layer.cornerRadius = 25
        
        cell.likeButton.titleLabel?.isHidden = true
        cell.likeButton.titleLabel?.removeFromSuperview()
//            cell.likeButton.layer.cornerRadius = 5
        cell.retweetButton.titleLabel?.isHidden = true
        cell.retweetButton.titleLabel?.removeFromSuperview()
//            cell.retweetButton.layer.cornerRadius = 5
        
        cell.likeButton.translatesAutoresizingMaskIntoConstraints = false
        cell.retweetButton.translatesAutoresizingMaskIntoConstraints = false
        cell.likeButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.retweetButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        cell.likeButton.imageView?.removeConstraints(cell.likeButton.imageView?.constraints ?? [])
        cell.retweetButton.imageView?.removeConstraints(cell.retweetButton.imageView?.constraints ?? [])
        
        
        NSLayoutConstraint.activate([
            cell.likeButton.leadingAnchor.constraint(equalTo: cell.profileImage.leadingAnchor),
            cell.likeButton.widthAnchor.constraint(equalTo: cell.likeButton.heightAnchor),
            cell.likeButton.topAnchor.constraint(equalTo: cell.profileImage.bottomAnchor, constant: 10),
            cell.likeButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10),
            
            cell.retweetButton.centerYAnchor.constraint(equalTo: cell.likeButton.centerYAnchor),
            cell.retweetButton.widthAnchor.constraint(equalTo: cell.likeButton.widthAnchor),
            cell.retweetButton.widthAnchor.constraint(equalTo: cell.retweetButton.heightAnchor),
            cell.retweetButton.leadingAnchor.constraint(equalTo: cell.likeButton.trailingAnchor, constant: 5),
            
            cell.likeButton.imageView!.topAnchor.constraint(equalTo: cell.likeButton.topAnchor),
            cell.likeButton.imageView!.bottomAnchor.constraint(equalTo: cell.likeButton.bottomAnchor),
            cell.likeButton.imageView!.leadingAnchor.constraint(equalTo: cell.likeButton.leadingAnchor),
            cell.likeButton.imageView!.trailingAnchor.constraint(equalTo: cell.likeButton.trailingAnchor),
            
            cell.retweetButton.imageView!.topAnchor.constraint(equalTo: cell.retweetButton.topAnchor),
            cell.retweetButton.imageView!.bottomAnchor.constraint(equalTo: cell.retweetButton.bottomAnchor),
            cell.retweetButton.imageView!.leadingAnchor.constraint(equalTo: cell.retweetButton.leadingAnchor),
            cell.retweetButton.imageView!.trailingAnchor.constraint(equalTo: cell.retweetButton.trailingAnchor),
        ])

//            if #available(iOS 15.0, *) {
//                cell.likeButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//                cell.retweetButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//            } else {
//                cell.likeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                cell.retweetButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetTableViewCell {
            // Stylistic things first
            styleCell(cell)
            
            let row = tweetCache[indexPath.row]
            
            cell.tweetId = row.object(forKey: "id") as? Int
            
            let retweeted: Bool = row.object(forKey: "retweeted") as? Bool ?? false
            let liked: Bool = row.object(forKey: "favorited") as? Bool ?? false
            cell.hasRetweeted = retweeted
            cell.hasLiked = liked
//            cell.hasRetweeted = retweeted == 0 ? false : true
//            cell.hasLiked = liked == 0 ? false : true
            
            cell.bindButtons()
            
            let userDict: NSDictionary? = row.object(forKey: "user") as? NSDictionary
            cell.handleLabel.text = userDict?.object(forKey: "name") as? String ?? ""
            if let imgUrl = userDict?.object(forKey: "profile_image_url_https") as? String {
                let imgURLWrapped = URL(string: imgUrl)!
                if let imageData = try? Data(contentsOf: imgURLWrapped) {
                    cell.profileImage.image = UIImage(data: imageData)
                }
            }
            cell.tweetContentLabel.text = (row.object(forKey: "text") as? String) ?? ""
            return cell
        }
        return UITableViewCell()
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 5 == tweetCache.count {
//            self.loadAdditionalTweets()
//        }
//    }

}

// MARK: Delegate extension
extension TimelineViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
}
