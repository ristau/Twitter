//
//  TwitterClient.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/10/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

let twitterConsumerKey = "t5elBIlUF11FMNU3rCNaSqttD"
let twitterConsumerSecret = "Xnfqw5IrkbW371vGhPUtmWYtPMhqGQgoNbLNXGBLCX0G69Xts8"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion:((user: User?, error: NSError?)-> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?)-> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //  print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            for tweet in tweets {
                print("text: \(tweet.text), created: \(tweet.createdAt)")
            }
            
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
            completion(tweets: nil, error: error)
        })
    }

    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //clear cache because the base class caches tokens
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        // Fetch request token and redirect to authorization page
        
        // Step 1: Get Request Token. The request token gives permission to send the user to the Twitter authentication mobile page
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterBFR://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            
            // Step 2: Authorize URL.  Once you have the token you can create the authURL
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }

    
    
    func openURL(url: NSURL){
        // Called when someone tries to redirect the User via URL
        // Steps: access the Twitter singleton
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            
            // save the access token in the Twitter Client
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user // this should persist the user as current user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation:NSURLSessionDataTask?, error: NSError!) -> Void in
                   print("error: \(error)")
                   self.loginCompletion?(user: nil, error: error)
            })
        }) {(error: NSError!) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
                }
            }
    
//    func favTweet(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?)-> ()){
//        
//        POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//            
//            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
//            
//            print("This is the favCount: \(tweet.favCount)")
//            
//            completion(tweet: tweet, error: nil)
//            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
//                print("ERROR: \(error)")
//                completion(tweet: nil, error: error)
//        })
//    }
    
    func retweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?)-> ()){
        
        POST("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            print("retweeted count: \(tweet.retweetTotal)")
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
                completion(tweet: nil, error: error)
        }
    }

    func favWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?)-> ()){
        
        POST("1.1/favorites/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            print("favorite count: \(tweet.favCount)")
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
                completion(tweet: nil, error: error)
        }
    }
    
    
    
    
}
