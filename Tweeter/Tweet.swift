//
//  Tweet.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var favorited: Bool = false
    var retweeted: Bool = false
    
    var user: User?
    
    var id: String?
    
    init(dictionary: NSDictionary){
        // print(dictionary)
        text = dictionary["text"] as? String
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString)
        }
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        favorited = (dictionary["favorited"] as? Bool)!
        retweeted = (dictionary["retweeted"] as? Bool)!
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        id = (dictionary["id_str"] as? String)
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
