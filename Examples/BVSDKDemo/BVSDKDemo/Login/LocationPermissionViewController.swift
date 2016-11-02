//
//  LocationPermissionViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionViewController: PermissionViewController, CLLocationManagerDelegate {
    var mngr: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.icon?.image = UIImage(named: "LocationIcon")
        
        self.titleLbl?.text = "Why share my location?"
        self.descLbl?.text = "By sharing your location with Endurance Cycles, we can provide you with a more robust instore shopping experience that inclues personalized product recommendations and easy access to product information."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func enablePressed(_ sender: UIButton) {

        if CLLocationManager.authorizationStatus() != .authorizedAlways{
            self.mngr = CLLocationManager()
            self.mngr.delegate = self
            self.mngr.requestAlwaysAuthorization()
        }
    }
    
    override func notNowPressed(_ sender: UIButton) {
        self.pushNotificationPermissionVC()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            self.pushNotificationPermissionVC()
        }
        
    }
    
    private func pushNotificationPermissionVC(){
        
        // Check that the user didn't already authorize notifications
        
        if UIApplication.shared.currentUserNotificationSettings!.types == UIUserNotificationType() {
            
            let lvc = NotificationPermissionViewController(nibName: "PermissionViewController", bundle:  nil)
            self.navigationController?.pushViewController(lvc, animated: true)
            
        } else {
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
