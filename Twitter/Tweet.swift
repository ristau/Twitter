//
//  Tweet.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/11/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?

 // constructor to accept a dictionary

init(dictionary: NSDictionary){
    
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    text = dictionary["text"] as? String
    createdAtString = dictionary["created_at"] as? String
    
    // code to parse string related to date format, Greenwich mean time
    // format code from the documentation
    
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:MM:ss Z y"
    createdAt = formatter.dateFromString(createdAtString!)
    
    }
    
    //convenience method to give us an array of tweets 
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

}

