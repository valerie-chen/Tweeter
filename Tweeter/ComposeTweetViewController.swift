//
//  ComposeTweetViewController.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/29/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var user: User = User.currentUser!
    var defaultText = "What's happening?" as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        tweetTextView.text = defaultText
        tweetTextView.textColor = UIColor.lightGrayColor()
        
        if user.defaultProfileImage! {
            profileImageView.image = UIImage(imageLiteral: "defaultEgg.png")
        } else {
            let imageUrl = user.profileUrl
            profileImageView.setImageWithURL(imageUrl!)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
        profileImageView.clipsToBounds = true
        

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == defaultText){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == ""){
            textView.text = defaultText
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        if (tweetTextView.text != "") {
            TwitterClient.sharedInstance.postTweet(tweetTextView.text, success: {
                self.dismissViewControllerAnimated(true, completion: {
                    
                })
                }, failure: { (error: NSError) in
                    print("error: \(error.localizedDescription)")
            })
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
