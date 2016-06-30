//
//  UserViewController.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/29/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileBorderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    
    var tweets: [Tweet]!
    
    var tweetCount: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        if user!.defaultProfileImage! {
            profileImageView.image = UIImage(imageLiteral: "defaultEgg.png")
        } else {
            let imageUrl = user!.profileUrl
            profileImageView.setImageWithURL(imageUrl!)
        }
        profileImageView.layer.zPosition = 2
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
        profileImageView.clipsToBounds = true
        
        profileBorderImageView.layer.cornerRadius = profileBorderImageView.frame.size.width / 10
        profileBorderImageView.clipsToBounds = true
        
        let backgroundUrl = user!.backgroundUrl
        if let backgroundUrl = backgroundUrl {
            backgroundImageView.setImageWithURL(backgroundUrl)
        } else {
            backgroundImageView.image = UIImage(imageLiteral: "light-blue-gradient.jpeg")
        }
        
        nameLabel.text = user!.name!
        screenNameLabel.text = "@" + user!.screenName!
        taglineLabel.text = user!.tagline
        
        followingCountLabel.text = Number.formatToString(user!.followingCount!)
        followersCountLabel.text = Number.formatToString(user!.followersCount!)
        
        nameLabel.sizeToFit()
        screenNameLabel.sizeToFit()
        taglineLabel.sizeToFit()
        followingCountLabel.sizeToFit()
        followersCountLabel.sizeToFit()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100.0;
        
        retrieveTimeline()
        
        // Do any additional setup after loading the view.
    }
    
    func retrieveTimeline(){
        TwitterClient.sharedInstance.userTimeline(user!.screenName!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil { // could this cause any problems?
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
