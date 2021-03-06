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
            profileImageView.setImageWith(URL(string: imageUrl!)!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
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
        
        
        retweetCountLabel.text! == "0" ? (retweetCountLabel.isHidden = true) : (retweetCountLabel.isHidden = false)
        favCountLabel.text! == "0" ? (favCountLabel.isHidden = true) : (favCountLabel.isHidden = false)
        
        tweetID = tweet.id
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil){
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), for: UIControlState())
                
                if self.retweetCountLabel.text! > "0" {
                    self.retweetCountLabel.text = String(self.tweet!.retweetTotal! + 1)
                } else {
                    self.retweetCountLabel.isHidden = false
                    self.retweetCountLabel.text = String(self.tweet!.retweetTotal! + 1)
                }
            }
                
            else {
                print ("ERROR rewtweeting: \(error)")
            }
        }
    }
    

    @IBAction func onFavorite(_ sender: AnyObject) {
        
        TwitterClient.sharedInstance.favWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil){
                self.favButton.setImage(UIImage(named: "like-action-on-red.png"), for: UIControlState())
                
                if self.favCountLabel.text! > "0" {
                    self.favCountLabel.text = String(self.tweet!.favCount! + 1)
                } else {
                    self.favCountLabel.isHidden = false
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARING FOR SEGUE")
        
        if segue.identifier == "Profile"{
            let user = tweet.user
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = user
            print("prepare for profile segue")
            }
            
        else if segue.identifier == "Reply" {
            
            let replyViewController = segue.destination as! ComposeViewController
            print("prepare for reply segue")
            
        }

        
//        let button = sender as! UIButton
//        let view = button.superview!
//        let cell = view.superview as! TweetCell
        
//        let indexPath = tableView.indexPath(cell)
//        let tweet = tweets![indexPath!.row]
        
       
        
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPathForCell(cell)
//        let tweet = tweets![indexPath!.row]
//        let detailViewController = segue.destinationViewController as! DetailViewController
//        detailViewController.tweet = tweet
        
        
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
