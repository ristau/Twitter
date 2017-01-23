//
//  TweetCell.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/14/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var tweetID: NSNumber?
    
    var tweet: Tweet! {
        
        didSet{
            
            if (tweet.user?.profileImageUrl != nil){
                let imageUrl = tweet.user?.profileImageUrl!
                profileImageView.setImageWith(URL(string: imageUrl!)!)
            } else{
                print("No profile image found")
            }
            
            tweetTextLabel.text = tweet.text!
            authorLabel.text = tweet.user?.name!
            timeCreatedLabel.text = tweet.createdAtString!
            userNameLabel.text = "@" + tweet.user!.screenname!
           
            tweetID = tweet.id!
            retweetCountLabel.text = String(tweet.retweetTotal!)
            favCountLabel.text = String(tweet.favCount!)
           
            
            retweetCountLabel.text! == "0" ? (retweetCountLabel.isHidden = true) : (retweetCountLabel.isHidden = false)
            favCountLabel.text! == "0" ? (favCountLabel.isHidden = true) : (favCountLabel.isHidden = false)
            
            tweetID = tweet.id
        //    favButton.setImage(UIImage(named: "like-action-off.png"), forState: UIControlState.Normal)
            
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
}
