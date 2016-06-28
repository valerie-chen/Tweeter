//
//  TweetCell.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit
import AFNetworking
import DateTools

class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let user = tweet.user!
            
            nameLabel.text = user.name as? String
            nameLabel.sizeToFit()
            
            screenNameLabel.text = "@" + (user.screenName as? String)!
            screenNameLabel.sizeToFit()
            
            postTextLabel.text = tweet.text as? String
            postTextLabel.sizeToFit()
            
            let imageUrl = user.profileUrl
            print(imageUrl)
            profileImageView.setImageWithURL(imageUrl!)
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
            
            let postDate = tweet.timeStamp
            let timeAgoDate = NSDate.shortTimeAgoSinceDate(postDate)
            timeStampLabel.text = timeAgoDate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
