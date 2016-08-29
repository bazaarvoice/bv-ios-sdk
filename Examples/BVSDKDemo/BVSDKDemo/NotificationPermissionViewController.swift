//
//  NotificationPermissionViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class NotificationPermissionViewController: PermissionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.icon?.image = UIImage(named: "notificationIcon")
        self.titleLbl?.text = "Why turn on notifications?"
        self.descLbl?.text = "By turning on notifications with Endurance Cycles, we can provide you with exclusive in-store recommendations."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func enablePressed(sender: UIButton) {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func notNowPressed(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

