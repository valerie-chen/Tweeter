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
    
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var likeView: UIImageView!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    let client = TwitterClient.sharedInstance
    
    var tweet: Tweet! {
        didSet {
            let user = tweet.user!
            
            nameLabel.text = user.name
            nameLabel.sizeToFit()
            
            screenNameLabel.text = "@" + user.screenName!
            screenNameLabel.sizeToFit()
            
            postTextLabel.text = tweet.text 
            postTextLabel.sizeToFit()
            
            // favorited = tweet.favorited
            if tweet.favorited {
                likeOn()
            } else {
                likeOff()
            }
            
            if tweet.retweeted {
                retweetView.image = UIImage(named: "retweet-action-green")
                let retweetColor = UIColor(red:0.10, green:0.81, blue:0.53, alpha:1.0)
                retweetCountLabel.textColor = retweetColor
            } else {
                retweetView.image = UIImage(named: "retweet-action")
                let retweetColor = UIColor(red:0.67, green:0.72, blue:0.76, alpha:1.0)
                retweetCountLabel.textColor = retweetColor
            }
            
            let imageUrl = user.profileUrl
            profileImageView.setImageWithURL(imageUrl!)
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
            profileImageView.clipsToBounds = true

            
            let postDate = tweet.timeStamp
            let timeAgoDate = NSDate.shortTimeAgoSinceDate(postDate)
            timeStampLabel.text = timeAgoDate
            
            retweetCountLabel.text = String(tweet.retweetCount)
            likeCountLabel.text = String(tweet.favoritesCount)
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
    
    func likeOn() {
        likeView.image = UIImage(named: "like-action-red")
        let likeColor = UIColor(red:0.91, green:0.11, blue:0.31, alpha:1.0)
        likeCountLabel.textColor = likeColor
    }
    
    func likeOff() {
        likeView.image = UIImage(named: "like-action")
        let likeColor = UIColor(red:0.67, green:0.72, blue:0.76, alpha:1.0)
        likeCountLabel.textColor = likeColor

    }
    
    func retweetOn() {
        retweetView.image = UIImage(named: "retweet-action-green")
        let retweetColor = UIColor(red:0.10, green:0.81, blue:0.53, alpha:1.0)
        retweetCountLabel.textColor = retweetColor
    }
    
    func retweetOff(){
        retweetView.image = UIImage(named: "retweet-action")
        let retweetColor = UIColor(red:0.67, green:0.72, blue:0.76, alpha:1.0)
        retweetCountLabel.textColor = retweetColor
    }
    
    @IBAction func onReplyButton(sender: AnyObject) {
        
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if tweet.retweeted {
            client.unretweetPost(tweet.id!, success: {
                self.retweetOff()
                self.retweetCountLabel.text = String(Int(self.retweetCountLabel.text!)! - 1)
                self.tweet.retweeted = false
                }, failure: { (error: NSError) in
                    print("Unretweet error: \(error.localizedDescription)")
            })
        } else {
            client.retweetPost(tweet.id!, success: {
                self.retweetOn()
                self.retweetCountLabel.text = String(Int(self.retweetCountLabel.text!)! + 1)
                self.tweet.retweeted = true
                }, failure: { (error: NSError) in
                    print("Retweet error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
        if tweet.favorited {
            client.unlikePost(tweet.id!, success: { 
                self.likeOff()
                self.likeCountLabel.text = String(Int(self.likeCountLabel.text!)! - 1)
                self.tweet.favorited = false
                }, failure: { (error: NSError) in
                    print("Unlike error: \(error.localizedDescription)")
            })
        } else {
            client.likePost(tweet.id!, success: {
                self.likeOn()
                self.likeCountLabel.text = String(Int(self.likeCountLabel.text!)! + 1)
                self.tweet.favorited = true
                }, failure: { (error: NSError) in
                    print("Like error: \(error.localizedDescription)")
            })
        }
    }
}
