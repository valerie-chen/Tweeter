//
//  MeViewController.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBorderImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    
    var user: User = User.currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.defaultProfileImage! {
            profileImageView.image = UIImage(imageLiteral: "defaultEgg.png")
        } else {
            let imageUrl = user.profileUrl
            profileImageView.setImageWithURL(imageUrl!)
        }
        profileImageView.layer.zPosition = 2
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
        profileImageView.clipsToBounds = true
        
        profileBorderImageView.layer.cornerRadius = profileBorderImageView.frame.size.width / 10
        profileBorderImageView.clipsToBounds = true
        
        let backgroundUrl = user.backgroundUrl
        if let backgroundUrl = backgroundUrl {
            backgroundImageView.setImageWithURL(backgroundUrl)
        } else {
            backgroundImageView.image = UIImage(imageLiteral: "light-blue-gradient.jpeg")
        }
        
        nameLabel.text = user.name!
        screenNameLabel.text = "@" + user.screenName!
        taglineLabel.text = user.tagline
        
        followingCountLabel.text = Number.formatToString(user.followingCount!)
        followersCountLabel.text = Number.formatToString(user.followersCount!)
        
        postsCountLabel.text = String(user.postsCount!)
        
        nameLabel.sizeToFit()
        screenNameLabel.sizeToFit()
        taglineLabel.sizeToFit()
        followingCountLabel.sizeToFit()
        followersCountLabel.sizeToFit()
        postsCountLabel.sizeToFit()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onComposeTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("meToComposeSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
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
