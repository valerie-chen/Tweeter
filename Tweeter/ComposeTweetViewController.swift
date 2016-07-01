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
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var inReplyLabel: UILabel!
    @IBOutlet weak var charactersLeftLabel: UILabel!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    let maxCharacters: Int = 140
    
    @IBOutlet weak var optionsViewToBottomConstraint: NSLayoutConstraint!
    
    var user: User = User.currentUser!
    var defaultText = "What's happening?" as String
    
    var keyboardHeight: CGFloat? = 0.0
    
    var inReplyTo: Tweet?
    var replyScreenName: String?
    var isReply: Bool = false
    
    var replyDefaultHeight: CGFloat = 0.0
    
    var inReplyText = "↓ In reply to "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        tweetTextView.text = defaultText
        tweetTextView.textColor = UIColor.lightGrayColor()
        tweetTextView.keyboardType = UIKeyboardType.Twitter
        
        if user.defaultProfileImage! {
            profileImageView.image = UIImage(imageLiteral: "defaultEgg.png")
        } else {
            let imageUrl = user.profileUrl
            profileImageView.setImageWithURL(imageUrl!)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 10
        profileImageView.clipsToBounds = true
        
        replyDefaultHeight = inReplyLabel.frame.size.height
        
        if (inReplyTo != nil){
            isReply = true
            replyScreenName = inReplyTo!.user!.screenName!
            inReplyLabel.text = inReplyText + replyScreenName!
            tweetTextView.text = "@\(replyScreenName!)" + " "
            tweetTextView.textColor = UIColor.blackColor()
        } else {
            inReplyLabel.frame.size.height = 0
            inReplyLabel.text = ""
        }
        
        checkReply()
        
        if (isReply) {
            print("reply\n")
            checkCharacters()
        } else {
            print("not a reply\n")
        }
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
//        print("\(String(keyboardHeight!))")
//        optionsViewToBottomConstraint.constant = keyboardHeight!
        // optionsView.transform = CGAffineTransformMakeTranslation( 0.0, -1 * keyboardHeight!)
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
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
        checkReply()
        checkCharacters()
    }
    
    func checkReply() {
        if (replyScreenName != nil){
            if tweetTextView.text.rangeOfString("@\(replyScreenName!)") == nil{
                inReplyLabel.frame.size.height = 0
                inReplyLabel.text = ""
                isReply = false
            } else {
                inReplyLabel.frame.size.height = replyDefaultHeight
                inReplyLabel.text = inReplyText + replyScreenName!
                isReply = true
            }
        } else {
            isReply = false
        }
    }
    
    func checkCharacters() {
        let charactersLeft = maxCharacters - tweetTextView.text.characters.count
        charactersLeftLabel.text = String(charactersLeft)
        if (charactersLeft > 0){
            charactersLeftLabel.textColor = UIColor.lightGrayColor()
        } else {
            charactersLeftLabel.textColor = UIColor.redColor()
        }
        
        if (charactersLeft < 0) {
            tweetButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            tweetButton.enabled = false
        } else {
            tweetButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            tweetButton.enabled = true
        }
    }
    
//    func keyboardShown(notification: NSNotification) {
//        let info  = notification.userInfo!
//        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
//        
//        let rawFrame = value.CGRectValue
//        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
//        
//        keyboardHeight = keyboardFrame.size.height
//        print("reached")
//    }
    
    @IBAction func onTweet(sender: AnyObject) {
        if (tweetTextView.text != "") {
            if (tweetTextView.text.characters.count > 140) {
                let alert = UIAlertView()
                alert.title = "Oops!"
                alert.message = "Tweet exceeds 140-character limit"
                alert.addButtonWithTitle("Edit Tweet")
                alert.show()
            } else {
                let client = TwitterClient.sharedInstance
                if (isReply) {
                    client.postReplyTweet(tweetTextView.text, inReplyToString: inReplyTo!.id!, success: {
                        self.dismissViewControllerAnimated(true, completion: {
                            
                        })
                        }, failure: { (error: NSError) in
                            print("error: \(error.localizedDescription)")
                    })
                } else {
                    client.postTweet(tweetTextView.text, success: {
                        self.dismissViewControllerAnimated(true, completion: {
                            
                        })
                        }, failure: { (error: NSError) in
                            print("error: \(error.localizedDescription)")
                    })
                }
            }
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
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
