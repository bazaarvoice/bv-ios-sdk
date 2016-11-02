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
        
        BVSDKManager.shared().clientId = "foobar"
        BVSDKManager.shared().setLogLevel(.analyticsOnly)
        //BVSDKManager.shared().apiKeyLocation = "badkey"
        BVSDKManager.shared().apiKeyConversations = "asdfasdf"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

