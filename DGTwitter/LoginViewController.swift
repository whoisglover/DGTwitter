//
//  LoginViewController.swift
//  DGTwitter
//
//  Created by Danny Glover on 4/12/17.
//  Copyright © 2017 Danny Glover. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    
        TwitterClient.sharedInstance?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }) { (error: Error) -> () in
            print(error.localizedDescription)
        }
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
