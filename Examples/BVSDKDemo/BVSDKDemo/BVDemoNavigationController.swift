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
    
    self.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.isTranslucent = false
    self.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
    self.navigationBar.tintColor = UIColor.white
    self.navigationBar.barStyle = .black;
  }
}
