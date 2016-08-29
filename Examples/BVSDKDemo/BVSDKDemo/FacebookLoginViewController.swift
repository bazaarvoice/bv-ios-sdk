//
//  FacebookLoginViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookLoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    let descriptionLabel = UILabel()
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        // check that user is logged in to facebook
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            fbLoginButton.removeFromSuperview()
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

}
