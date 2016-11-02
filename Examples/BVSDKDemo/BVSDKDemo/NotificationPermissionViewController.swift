//
//  NotificationPermissionViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import UserNotifications

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
    
    override func enablePressed(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]){ (success, error) in
            };
        }else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func notNowPressed(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

