//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/13/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
        
            if (tweets != nil) {
                self.tweets = tweets
                // reload tableview here if you have one with self.tableView.reloadData()
            }
            
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onLogout(sender: AnyObject) {
        // clears the Twitter access token
        // clears current user from persistence
        // fires a global notification that the user logged out
        
        User.currentUser?.logout()
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
