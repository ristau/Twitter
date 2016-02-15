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
    
    
    var tweet: Tweet! {
        
        didSet{
            
            let imageUrl = tweet.user?.profileImageUrl!
            profileImageView.setImageWithURL(NSURL(string: imageUrl!)!)
            
            tweetTextLabel.text = tweet.text!
            userNameLabel.text = tweet.user?.name!
            timeCreatedLabel.text = tweet.createdAtString
            authorLabel.text = "@" + tweet.user!.screenname!
           
            retweetCountLabel.text = String(tweet.retweetTotal!)
            favCountLabel.text = "\(tweet.favCount as! Int)"
            print ("Favorite Count: \(tweet.favCount as! Int)")
            
            retweetCountLabel.text! == "0" ? (retweetCountLabel.hidden = true) : (retweetCountLabel.hidden = false)
            favCountLabel.text! == "0" ? (favCountLabel.hidden = true) : (favCountLabel.hidden = false)
            
            favButton.setImage(UIImage(named: "like-action-off.png"), forState: UIControlState.Normal)
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func onRetweet(sender: AnyObject) {
        
//    TwitterClient.sharedInstance.retweet(Int(tweetID), params: nil, completion: {(error) -> () in
//        self.retweetButton.setImage(UIImage(named: "retweet-action"), forState: UIControlState.Selected)
//        
//        if self.retweetCountLabel.text! > "0" {
//            self.retweetCountLabel.text = String(self.tweet.retweetTotal! + 1)
//        }
//        
//    
//    
//    })

        
//            if (tweets != nil) {
//                self.tweets = tweets
//                self.tableView.reloadData()
//                //refresh end
//            }
      //  }

        
    }
    
    @IBAction func onFav(sender: AnyObject) {
        
        
    }
    
}
