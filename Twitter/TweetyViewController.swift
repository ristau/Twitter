//
//  TweetyViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/13/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

class TweetyViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var favButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 120
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //implement refresh control
        
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            if (tweets != nil) {
                self.tweets = tweets
                self.tableView.reloadData()
                //refresh end
            }
        }


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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweetTextLabel.text = tweets![indexPath.row].text!
        cell.userNameLabel.text = tweets![indexPath.row].user?.name!
        cell.timeCreatedLabel.text = tweets![indexPath.row].createdAtString
        cell.authorLabel.text = "@" + tweets![indexPath.row].user!.screenname!
        
        
        
        
//        cell.tweetContent.text = tweets![indexPath.row].text!
       // tweetTextLabel.text = tweets![indexPath.row]
    //    cell.tweet = tweets![indexPath.row]
        
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as! String
//        
//        cell.titleLabel.text = title
        //let tweetContent = tweet.text

        
//        if (tweets != nil) {
//            let cell = tweets![indexPath.row]
//        }
        
        
       // cell.textLabel!.text = "row \(indexPath.row)"
        print ("row \(indexPath.row)")

        return cell
    
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
