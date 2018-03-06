//
//  LocationPermissionViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class PermissionViewController: UIViewController {
  
  @IBOutlet var titleLbl: UILabel?
  @IBOutlet var icon: UIImageView?
  @IBOutlet var descLbl: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // set the icon color mask
    self.icon!.image? = (self.icon!.image?.withRenderingMode(.alwaysTemplate))!
    self.icon!.tintColor = UIColor.bazaarvoiceNavy()
  }
  
  
  @IBAction func enablePressed(_ sender: UIButton){
    
  }
  
  
  @IBAction func notNowPressed(_ sender: UIButton){
    
  }
}
