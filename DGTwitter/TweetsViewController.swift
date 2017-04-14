//
//  TweetsViewController.swift
//  DGTwitter
//
//  Created by Danny Glover on 4/13/17.
//  Copyright © 2017 Danny Glover. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let icon = UIImage(named: "birdBlue")
        let birdImageView = UIImageView(image: icon)
        navigationItem.titleView = birdImageView
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: "titleWasTapped")
        
        birdImageView.isUserInteractionEnabled = true
        birdImageView.addGestureRecognizer(recognizer)
//        navigationItem.titleView.userInteractionEnabled = true
//        titleView.addGestureRecognizer(recognizer)
        
        
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text)
            }
            //reload tableview data
            
        }, failure: { (error: Error) -> () in
            //
        })
        
        
    }
    
    func titleWasTapped() {
        print("title was tapped! wooo")
    }
    @IBAction func onLogoutButton(_ sender: Any) {
        print("logout button pressed")
        TwitterClient.sharedInstance?.logout()
    }


}
