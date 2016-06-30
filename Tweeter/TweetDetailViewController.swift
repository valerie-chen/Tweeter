//
//  TweetDetailViewController.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/28/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet!
    
    let client = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = tweet.user! as User
        nameLabel.text = user.name!
        nameLabel.sizeToFit()
        
        screenNameLabel.text = "@" + user.screenName!
        screenNameLabel.sizeToFit()

        postTextLabel.text = tweet.text!
        postTextLabel.sizeToFit()
        
        let imageUrl = user.profileUrl
        profileImageView.setImageWithURL(imageUrl!)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
        profileImageView.clipsToBounds = true
        
        timeStampLabel.text = Number.formatDateToStandardString(tweet.timeStamp!)
        
        retweetCountLabel.text = String(tweet.retweetCount)
        likeCountLabel.text = String(tweet.favoritesCount)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func likeOn() {
        likeButton.imageView?.image = UIImage(named: "like-action-red")
        likeCountLabel.text = String(Int(self.likeCountLabel.text!)! + 1)
        tweet.favorited = true
    }
    
    func likeOff() {
        likeButton.imageView?.image = UIImage(named: "like-action")
        likeCountLabel.text = String(Int(self.likeCountLabel.text!)! - 1)
        tweet.favorited = false
    }
    
    func retweetOn() {
        retweetButton.imageView?.image = UIImage(named: "retweet-action-green")
        retweetCountLabel.text = String(Int(self.retweetCountLabel.text!)! + 1)
        tweet.retweeted = true
    }
    
    func retweetOff(){
        retweetButton.imageView?.image = UIImage(named: "retweet-action")
        retweetCountLabel.text = String(Int(self.retweetCountLabel.text!)! - 1)
        tweet.retweeted = false
    }

    
    @IBAction func onUserButton(sender: AnyObject) {
        performSegueWithIdentifier("tweetDetailToUserSegue", sender: nil)
    }
    
    @IBAction func onReplyButton(sender: AnyObject) {
        performSegueWithIdentifier("detailReplyToComposeSegue", sender: nil)
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if tweet.retweeted {
            client.unretweetPost(tweet.id!, success: {
                self.retweetOff()
                }, failure: { (error: NSError) in
                    print("Unretweet error: \(error.localizedDescription)")
            })
        } else {
            client.retweetPost(tweet.id!, success: {
                self.retweetOn()
                }, failure: { (error: NSError) in
                    print("Retweet error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
        if tweet.favorited {
            client.unlikePost(tweet.id!, success: {
                self.likeOff()
                }, failure: { (error: NSError) in
                    print("Unlike error: \(error.localizedDescription)")
            })
        } else {
            client.likePost(tweet.id!, success: {
                self.likeOn()
                }, failure: { (error: NSError) in
                    print("Like error: \(error.localizedDescription)")
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailToUserSegue"){
            let destinationVC = segue.destinationViewController as! UserViewController
            destinationVC.user = tweet.user
        } else if (segue.identifier == "detailReplyToComposeSegue"){
            let destinationVC = segue.destinationViewController as! ComposeTweetViewController
            destinationVC.inReplyTo = tweet
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
