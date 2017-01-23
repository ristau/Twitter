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
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion:((_ user: User?, _ error: NSError?)-> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        
        return Static.instance!
    }
    
    func homeTimelineWithParams(_ params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?)-> ()){
        
        get("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: URLSessionDataTask?
        , response: Any?) -> Void in
            //  print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            for tweet in tweets {
                print("text: \(tweet.text), created: \(tweet.createdAt)")
            }
            
            completion(tweets, nil)
            }, failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                print("error: \(error)")
            completion(nil, error)
        })
    }

    
    func loginWithCompletion(_ completion: @escaping (_ user: User?, _ error: NSError?) -> ()){
        loginCompletion = completion
        
        //clear cache because the base class caches tokens
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        // Fetch request token and redirect to authorization page
        
        // Step 1: Get Request Token. The request token gives permission to send the user to the Twitter authentication mobile page
        
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "cptwitterBFR://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential?) -> Void in
            print("Got the request token")
            
            // Step 2: Authorize URL.  Once you have the token you can create the authURL
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken?.token)")
            UIApplication.shared.openURL(authURL!)
            
            }) { (error: Error?) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(nil, error as NSError?)
            }
    }

    
    
    func openURL(_ url: URL){
        // Called when someone tries to redirect the User via URL
        // Steps: access the Twitter singleton
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Got the access token!")
            
            // save the access token in the Twitter Client
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
                
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user // this should persist the user as current user
                print("user: \(user.name)")
                self.loginCompletion?(user, nil)
                }, failure: { (operation:URLSessionDataTask?, error: Error!) -> Void in
                   print("error: \(error)")
                   self.loginCompletion?(nil, error as NSError?)
            })
        }) {(error: Error?) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(nil, error as NSError?)
                }
            }
    
    
    func retweetWithCompletion(_ params: NSDictionary?, completion: @escaping (_ tweet: Tweet?, _ error: Error?)-> ()){
        
        post("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: URLSessionDataTask?, response: Any?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            print("retweeted count: \(tweet.retweetTotal)")
            
            completion(tweet, nil)
            
            }) { (operation: URLSessionDataTask?, error: Error) -> Void in
                print("error: \(error)")
                completion(nil, error)
        }
    }

    func favWithCompletion(_ params: NSDictionary?, completion: @escaping (_ tweet: Tweet?, _ error: Error?)-> ()){
        
        post("1.1/favorites/create.json", parameters: params, success: { (operation: URLSessionDataTask, response: Any?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            print("favorite count: \(tweet.favCount)")
            
            completion(tweet, nil)
            
            }) { (operation: URLSessionDataTask?, error: Error) -> Void in
                print("error: \(error)")
                completion(nil, error)
        }
    }
    
//    func getUserBanner(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
//    GET("1.1/users/profile_banner.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//        print("got user banner")
//        completion( error: nil)
//        }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
//            print("did not get user banner")
//            completion(error: error)
//        })
//    }
    
    func compose(_ escapedTweet: String, params: NSDictionary?, completion: @escaping (_ error: Error?) -> () ){
        post("1.1/statuses/update.json?status=\(escapedTweet)", parameters: params, success: { (operation: URLSessionDataTask, response: Any?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(nil)
            }, failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
                print ("could not compose tweet")
                completion(error)
        }
        )
    }
    
    func reply(_ escapedTweet: String, statusID: Int, params: NSDictionary?, completion: @escaping (_ error: Error?) -> () ){
        post("1.1/statuses/update.json?in_reply_to_status_id=\(statusID)&status=\(escapedTweet)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(nil)
            }, failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
                print ("could not reply")
                completion(error)
            }
        )
    }
    
    
    
    
}
