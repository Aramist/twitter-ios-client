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
        
        self.tweetTable.dataSource = self
        self.tweetTable.delegate = self
        
        self.getTweets()
        
        self.refreshControl.addTarget(self, action: #selector(reloadTweets), for: .valueChanged)
        self.tweetTable.refreshControl = self.refreshControl
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
        
        self.getTweets(specialParams)
    }
    
    @objc func reloadTweets() {
        self.getTweets(nil, wipeCache: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "UserLoggedIn")
        defaults.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetCache.count
    }
    
    
}

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetTableViewCell {
            // Stylistic things first
            cell.profileImage.layer.cornerRadius = 25
            let row = indexPath.row
           
            let userDict: NSDictionary? = tweetCache[row].object(forKey: "user") as? NSDictionary
            cell.handleLabel.text = userDict?.object(forKey: "name") as? String ?? ""
            
            if let imgUrl = userDict?.object(forKey: "profile_image_url_https") as? String {
                let imgURLWrapped = URL(string: imgUrl)!
                if let imageData = try? Data(contentsOf: imgURLWrapped) {
                    cell.profileImage.image = UIImage(data: imageData)
                }
            }
            cell.tweetContentLabel.text = (tweetCache[row].object(forKey: "text") as? String) ?? ""
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 5 == tweetCache.count {
            self.loadAdditionalTweets()
        }
    }

}

extension TimelineViewController: UITableViewDelegate {
    
}
