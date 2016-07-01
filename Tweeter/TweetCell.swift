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
    
    @IBOutlet weak var retweetedView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    var retweetedOf: NSDictionary?
    
    @IBOutlet weak var retweetedLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var retweetedViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabelTop: NSLayoutConstraint!
    
    let client = TwitterClient.sharedInstance
    
    var tweet: Tweet! {
        didSet {
            retweetedOf = tweet.retweetedTweet
            if retweetedOf == nil {
                formatCell(tweet)
                profileImageView.frame = CGRectMake(profileImageView.frame.origin.x, profileImageView.frame.origin.y - 8, profileImageView.frame.width, profileImageView.frame.height)
                retweetedLabel.hidden = true
                retweetedView.hidden = true
//                retweetedLabelHeight = NSLayoutConstraint(item: retweetedLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
//                retweetedViewHeight = NSLayoutConstraint(item: retweetedView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
//                
//                NSLayoutConstraint.activateConstraints([retweetedLabelHeight!, retweetedViewHeight!])
//                retweetedView.frame.size = CGSize(width: 0.0, height: 0.0)
//                retweetedLabel.frame.size = CGSize(width: 0.0, height: 0.0)
//                print(String(retweetedView.frame.height))
//                retweetedViewHeight.active = false
//                retweetedView.translatesAutoresizingMaskIntoConstraints = true
//                retweetedLabel.translatesAutoresizingMaskIntoConstraints = true
//                retweetedView.frame = CGRectMake(retweetedView.frame.origin.x, retweetedView.frame.origin.y, /*retweetedView.frame.width*/ 0.0, 0.0)
//                retweetedLabel.frame = CGRectMake(retweetedLabel.frame.origin.x, retweetedLabel.frame.origin.y, /*retweetedLabel.frame.width*/ 0.0, 0.0)
                
            } else {
                
                let newTweet = Tweet(dictionary: retweetedOf!)
                formatCell(newTweet)
//                retweetedViewHeight.active = true
//                retweetedLabel.text = "\(tweet!.user!.name!) Retweeted"
//                retweetedLabelHeight = NSLayoutConstraint(item: retweetedLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 15.5)
//                retweetedViewHeight = NSLayoutConstraint(item: retweetedView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 15.5)
//                
//                NSLayoutConstraint.activateConstraints([retweetedLabelHeight!, retweetedViewHeight!])
            }
        }
    }
    
    func formatCell(tweet: Tweet) {
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
