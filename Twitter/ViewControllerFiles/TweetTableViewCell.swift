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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
