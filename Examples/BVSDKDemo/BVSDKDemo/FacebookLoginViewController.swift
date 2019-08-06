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
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    self.navigationController?.isNavigationBarHidden = true
    
    // check that user is logged in to facebook
    if(FBSDKAccessToken.current() != nil) {
      fbLoginButton.removeFromSuperview()
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
}
