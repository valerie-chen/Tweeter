//
//  User.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit
import Foundation

class User: NSObject {
    
    static let logoutNotification = "UserDidLogout"

    var name: String?
    var screenName: String?
    
    var defaultProfileImage: Bool?
    var profileUrl: NSURL?
    
    var backgroundUrl: NSURL?
    
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    var followingCount: Int?
    var followersCount: Int?
    
    var postsCount: Int?

    init(dictionary: NSDictionary){
        self.dictionary = dictionary
       // print(dictionary)
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        defaultProfileImage = dictionary["default_profile_image"] as? Bool
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            let modifiedProfileUrlString = profileUrlString.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
            profileUrl = NSURL(string: modifiedProfileUrlString)
        }
        
        if let backgroundUrlString = dictionary["profile_banner_url"] as? String {
            backgroundUrl = NSURL(string: backgroundUrlString)
        }
        
        tagline = dictionary["description"] as? String
        
        followingCount = dictionary["friends_count"] as? Int ?? 0
        followersCount = dictionary["followers_count"] as? Int ?? 0
        
        postsCount = dictionary["statuses_count"] as? Int ?? 0
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
