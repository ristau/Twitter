//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/28/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var user: User?
    var tweet: Tweet?
    var author: String?
    var tweetContent: String = ""
    var isReply: Bool?
    
    
     @IBOutlet weak var composeButton: UINavigationItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var charLimitLabel: UILabel!
    @IBOutlet weak var createTweet: UIBarButtonItem!
    @IBOutlet weak var composeNewTweet: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        composeNewTweet.delegate = self
        authorLabel.text = "@\(User.currentUser!.screenname!)"
        userNameLabel.text = User.currentUser!.name!
        
        if (user?.profileImageUrl != nil){
            let imageUrl = user?.profileImageUrl!
            profileImageView.setImageWithURL(NSURL(string: imageUrl!)!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
        } else{
            print("No profile image found")
        }
        
        placeHolderLabel.text = ""
        
        composeNewTweet.addSubview(placeHolderLabel)
        placeHolderLabel.hidden = !composeNewTweet.text.isEmpty
        
        composeNewTweet.becomeFirstResponder()
        
        if (isReply) == true {
            composeNewTweet.text = "@\((tweet?.user?.screenname)!)"
            if 0 < (141 - composeNewTweet.text!.characters.count){
                createTweet.enabled = true
                charLimitLabel.text = "\(140-composeNewTweet.text!.characters.count)"
            }
            else {
                createTweet.enabled = false
                charLimitLabel.text = "\(140 - composeNewTweet.text!.characters.count)"
            }
            isReply = false
          
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCreateNewTweet(sender: AnyObject) {
        
        tweetContent = composeNewTweet.text
        
        let escapedTweetMessage = tweetContent.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if isReply == true {
            placeHolderLabel.hidden = !composeNewTweet.text.isEmpty
            TwitterClient.sharedInstance.reply(escapedTweetMessage!, statusID: Int(tweet!.id!), params: nil, completion: {
                    (error) -> () in
                    print("replying")
            })
            isReply = false
            navigationController?.popViewControllerAnimated(true)
        } else {
            TwitterClient.sharedInstance.compose(escapedTweetMessage!, params: nil, completion: { (error) -> () in
                print("composing tweet")
            })
            navigationController?.popViewControllerAnimated(true)
        }
            
        }
    
    func textViewDidChange(textView: UITextView) {
        placeHolderLabel.hidden = !composeNewTweet.text.isEmpty
        if 0 < (141 - composeNewTweet.text!.characters.count) {
            createTweet.enabled = true
            charLimitLabel.text = "\(140 - composeNewTweet.text!.characters.count)"
        }
        
        else {
            createTweet.enabled = false
            charLimitLabel.text = "\(140 - composeNewTweet.text!.characters.count)"
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

