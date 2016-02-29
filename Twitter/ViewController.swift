//
//  ViewController.swift
//  Twitter
//
//  Created by Barbara Ristau on 2/8/16.
//  Copyright © 2016 Barbara. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager



class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        // you could also consider to put this codeblock in your User Class
        // you would do this if you want to fully hide the API client from the View Controller level 
        // for example, change method to user.loginWithCompletion, which calls method below
        
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            if user != nil{
                
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else{
                //handle login error
            }
            
        }
    }

}