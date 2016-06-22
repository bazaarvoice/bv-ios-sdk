//
//  FacebookLoginViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookLoginViewController: UIViewController {
    
    let button = FBSDKLoginButton()
    let descriptionLabel = UILabel()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // check that user is logged in to facebook
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            self.view.addSubview(button)
        }
        else {
            button.removeFromSuperview()
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        button.center = self.view.center
    }

}
