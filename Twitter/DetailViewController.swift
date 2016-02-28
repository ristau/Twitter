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
    

    @IBAction func onLike(sender: AnyObject) {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}