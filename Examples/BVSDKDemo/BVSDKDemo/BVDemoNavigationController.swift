//
//  BVDemoNavigationController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class BVDemoNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barStyle = .Black;
    }    
}
