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
    var author: String?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var id: NSNumber?
    var favCount: Int!
    var retweetTotal: Int!
//    var retweetImage: UIImage?
//    var favImage: UIImage?

 // constructor to accept a dictionary

init(dictionary: NSDictionary){
    
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    author = dictionary["author"] as? String
    
    text = dictionary["text"] as? String
    createdAtString = dictionary["created_at"] as? String
    
    // code to parse string related to date format, Greenwich mean time
    // format code from the documentation
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE MMM d HH:MM:ss Z y"
    createdAt = formatter.date(from: createdAtString!)
    
    
    // code for retweeting and favorites
    id = dictionary["id"] as? Int as NSNumber?
    
    favCount = dictionary["favorite_count"] as? Int
    retweetTotal = dictionary["retweet_count"] as? Int
    
    }
    
    //convenience method to give us an array of tweets 
    class func tweetsWithArray(_ array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

    //convenience method for converting dictionary to a single tweet
    class func tweetAsDictionary(_ dict: NSDictionary) -> Tweet {

        let tweet = Tweet(dictionary: dict)
        
        return tweet
    }

    
}

