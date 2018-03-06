//
//  ViewController.swift
//  CarthageTest
//
//  Copyright (c) 2015 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let config = [
      "clientId" : "foobar",
      "apiKeyConversations" : "badkey"
    ]
    BVSDKManager.configure(withConfiguration: config, configType: .staging)
    BVSDKManager.shared().setLogLevel(.analyticsOnly)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

