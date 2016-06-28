//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "Xq7I5mjt8xpYDjoGHeDxPneu2", consumerSecret: "mJiVAVyrFjsFu8ieNeLz4WB9odtNu4c8CoSiqeJh65AuiFKAzb")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "valerietweeter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("Got Token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.logoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            print("Got Access Token")
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
        }) { (error: NSError!) in
            
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
            
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
}
