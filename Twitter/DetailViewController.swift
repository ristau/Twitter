//
//  DetailViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/25/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet!
    var tweetID: NSNumber?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tweet.text)
        
        if (tweet.user?.profileImageUrl != nil){
            let imageUrl = tweet.user?.profileImageUrl!
            profileImageView.setImageWithURL(NSURL(string: imageUrl!)!)
        } else{
            print("No profile image found")
        }
        
        tweetTextLabel.text = tweet.text!
        tweetTextLabel.sizeToFit()
        authorLabel.text = tweet.user?.name!
        timeCreatedLabel.text = tweet.createdAtString!
        userNameLabel.text = "@" + tweet.user!.screenname!
        
        tweetID = tweet.id!
        retweetCountLabel.text = String(tweet.retweetTotal!)
        favCountLabel.text = String(tweet.favCount!)
        
        
        retweetCountLabel.text! == "0" ? (retweetCountLabel.hidden = true) : (retweetCountLabel.hidden = false)
        favCountLabel.text! == "0" ? (favCountLabel.hidden = true) : (favCountLabel.hidden = false)
        
        tweetID = tweet.id
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil){
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
                
                if self.retweetCountLabel.text! > "0" {
                    self.retweetCountLabel.text = String(self.tweet!.retweetTotal! + 1)
                } else {
                    self.retweetCountLabel.hidden = false
                    self.retweetCountLabel.text = String(self.tweet!.retweetTotal! + 1)
                }
            }
                
            else {
                print ("ERROR rewtweeting: \(error)")
            }
        }
    }
    

    @IBAction func onFavorite(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil){
                self.favButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
                
                if self.favCountLabel.text! > "0" {
                    self.favCountLabel.text = String(self.tweet!.favCount! + 1)
                } else {
                    self.favCountLabel.hidden = false
                    self.favCountLabel.text = String(self.tweet!.favCount! + 1)
                }
            }
                
            else {
                print ("ERROR favorite: \(error)")
            }
            
        }
        
        
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        let button = sender as! UIButton
//        let view = button.superview!
//        let cell = view.superview as! TweetCell
        
//        let indexPath = tableView.indexPath(cell)
//        let tweet = tweets![indexPath!.row]
        
        let user = tweet.user
        let profileViewController = segue.destinationViewController as! ProfileViewController
        profileViewController.user = user
        
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPathForCell(cell)
//        let tweet = tweets![indexPath!.row]
//        let detailViewController = segue.destinationViewController as! DetailViewController
//        detailViewController.tweet = tweet
        
        
        print("prepare for segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}