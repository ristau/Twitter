//
//  User.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/11/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

var _currentUser: User?

let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var bannerImageUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary
    var tweetCount: Int
    var followingTotal: Int
    var followersTotal: Int
    var userID: Int
    
    // constructor to accept a dictionary
    
    init(dictionary: NSDictionary){
        
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
        userID = dictionary["id"] as! Int
        followersTotal = dictionary["followers_count"] as! Int
        followingTotal = dictionary["friends_count"] as! Int
        tweetCount = dictionary["statuses_count"] as! Int
        
        let banner = dictionary["profile_background_image_url_https"] as? String
        if banner != nil{
            bannerImageUrl = URL(string: banner!)
        }
        
    
    }
    
    func logout() {
        // clear user info and send notification that logout happened
        User.currentUser = nil
        // clear the access token
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        // send broadcast that the user logged out 
        NotificationCenter.default.post(name: Notification.Name(rawValue: userDidLogoutNotification), object: nil)
    }
    
        // methods to store and restore current user


    class var currentUser: User?{
        
        get {
            if _currentUser == nil {
            let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
                if data != nil {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                    } catch (let error) {
                        print(error)
                    }
                }
            }
        return _currentUser
        }
        
            set(user) {
                _currentUser = user
                
                if (_currentUser != nil) {
                    do {
                        // if current user is not nil, change it to the JSON serialized string
                        let data = try JSONSerialization.data(withJSONObject: user!.dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                        // store it in the key
                        UserDefaults.standard.set(data, forKey: currentUserKey)
                       //  save (write or flush) it to disk
                        UserDefaults.standard.synchronize()
                    } catch (let error) {
                        print(error)
                        // even if it's nil you still want to clear it
                        UserDefaults.standard.set(nil, forKey: currentUserKey)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
        
    }
