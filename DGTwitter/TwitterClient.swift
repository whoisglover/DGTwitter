//
//  TwitterClient.swift
//  DGTwitter
//
//  Created by Danny Glover on 4/13/17.
//  Copyright © 2017 Danny Glover. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    
    
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com"), consumerKey:"Mnj3jrPySwJjj7LWvHkQFYjWM",
        consumerSecret: "tHWjis54o9cZt3XN352YHsSYk7LTob2wlr4rS9Jug1QjmaKHyP")
    
    var loginSuccess: (()->())?
    var loginFailure: ((Error)->())?
    
    
    func login(success: @escaping ()-> (), failure: (Error)->()){
        
        loginSuccess = success

        
        deauthorize()
        fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "dgtwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token! \(requestToken!.token!)")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: { (bool: Bool) -> Void in
                print("completion handler fired")
            })
            
            
        }, failure: { (error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        
        
        User.currentUser = nil
        
        print("logout starting")
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogOut"), object: nil)
        
    }
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user 
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) -> Void in
            print("access token error: \(error!)")
            self.loginFailure?(error!)
        })
    
    }
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, success: { (task, response) -> Void in
            // code here
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task, error) -> Void in
            failure(error)
            print("here-------------")
            print("error: \(error)")
        })

    }
    
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error)->()) {
        get("1.1/account/verify_credentials.json", parameters: nil, success: { (task, response) -> Void in
            // code here
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            success(user)
        
        }, failure: { (task, error) -> Void in
            failure(error)
        })
        
    }
    
}