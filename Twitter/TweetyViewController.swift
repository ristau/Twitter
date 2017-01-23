//
//  TweetyViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/13/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

class TweetyViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var tweet: Tweet!
    var refreshControl: UIRefreshControl!
    var favButton: UIButton!
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //implement refresh control
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action:
            "onRefresh", for: UIControlEvents.valueChanged)
            
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            if (tweets != nil) {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     //  handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                //loadmoreData function
                
            }
            
            
        }
    }
    
//    func loadMoreData(){
    
        // }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
    
//        let imageUrl = tweets![indexPath.row].user?.profileImageUrl!
//        cell.profileImageView.setImageWithURL(NSURL(string: imageUrl!)!)
//        
//        cell.tweetTextLabel.text = tweets![indexPath.row].text!
//        cell.userNameLabel.text = tweets![indexPath.row].user?.name!
//        cell.timeCreatedLabel.text = tweets![indexPath.row].createdAtString
//        cell.authorLabel.text = "@" + tweets![indexPath.row].user!.screenname!
//        
//        cell.retweetCountLabel.text = tweets![indexPath.row].retweetTotal!
        
        
        
        return cell
        
    }
    
    
    
//    @IBAction func onFav(sender: AnyObject) {
//        print("Clicked on Favorite")
//        
//        
////        TwitterClient.sharedInstance.favTweet(["id": tweetID!]) {(tweet, error) -> () in
////                    if (tweet != nil) {
////                        print ("Successfully saved as favorite. Increment count")
////                        self.tweets![indexPath.row] = tweet!
////                        self.tableView.reloadData()
////                }
////            }
//
//        
//        
//        
//    }

    

    @IBAction func onLogout(_ sender: AnyObject) {
                // clears the Twitter access token
                // clears current user from persistence
                // fires a global notification that the user logged out
        
        User.currentUser?.logout()
        
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.tweet = tweet
        
        print("prepare for detail segue")
            
        }
        
        else if segue.identifier == "Profile"{
            
             //let cell = sender as! UIButton
             let indexPath = tableView.indexPathForSelectedRow
             let tweet = tweets![indexPath!.row]
             let user = tweet.user
             let profileViewController = segue.destination as! ProfileViewController
             profileViewController.user = user
             print("prepare for profile segue")
            }
            
        
        else if segue.identifier == "Compose" {
          
           // let composeViewController = segue.destinationViewController as! ComposeViewController
            print("prepare for compose segue")
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
