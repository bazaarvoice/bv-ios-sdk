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
         self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // set the icon color mask
        self.icon!.image? = (self.icon!.image?.imageWithRenderingMode(.AlwaysTemplate))!
        self.icon!.tintColor = UIColor.bazaarvoiceNavy()
    }

    
    @IBAction func enablePressed(sender: UIButton){
        
    }
    
    
    @IBAction func notNowPressed(sender: UIButton){

    }
}
