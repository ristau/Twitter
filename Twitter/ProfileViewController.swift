//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/26/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit
import AFNetworking


class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var tweetsTotalLabel: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    
    @IBOutlet weak var followingTotalLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var followersTotalLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    
    var user: User? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (user?.profileImageUrl != nil){
            let imageUrl = user?.profileImageUrl!
            profileImageView.setImageWithURL(NSURL(string: imageUrl!)!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
        } else{
            print("No profile image found")
        }
  
        bannerImageView.setImageWithURL((user?.bannerImageUrl!)!)
        
        authorLabel.text = user?.name!
        userNameLabel.text = "@" + user!.screenname!
        
        tweetsCount.text = String(user!.tweetCount)
        
        followersCount.text = String(user!.followersTotal)
        followingCount.text = String(user!.followingTotal)

        
    }

    
        // Do any additional setup after loading the view.
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
