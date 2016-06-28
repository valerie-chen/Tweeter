//
//  Tweet.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var user: User?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString)
        }
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
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
