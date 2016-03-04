//
//  SettingsViewController.swift
//  BVProductRecsExample
//
//  Created by Bazaarvoice on 1/11/16.
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var clientIdTextField: UITextField!
    
    @IBOutlet weak var hideStarsSwitch: UISwitch!
    @IBOutlet weak var customStarsSwitch: UISwitch!
    @IBOutlet weak var starColorSegControl: UISegmentedControl!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadSettings()
        
        self.apiKeyTextField.delegate = self
        self.clientIdTextField.delegate = self
        
    }
    
    func loadSettings() -> Void {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        var apiKey = prefs.stringForKey("apiKey")
        var clientId = prefs.stringForKey("clientId")
        let hideStars:Bool = prefs.boolForKey("hidestars")
        let customStars:Bool = prefs.boolForKey("customstars")
        let colorIndex = prefs.integerForKey("starcolorindex")
        
        if (apiKey != nil) {
            BVSDKManager.sharedManager().apiKeyShopperAdvertising = apiKey!
        }else{
            // default
            prefs.setValue(BVSDKManager.sharedManager().apiKeyShopperAdvertising, forKey: "apiKey")
            apiKey = BVSDKManager.sharedManager().apiKeyShopperAdvertising
        }
        
        if (clientId != nil) {
            BVSDKManager.sharedManager().clientId = clientId!
        } else {
            // default
            prefs.setValue(BVSDKManager.sharedManager().clientId, forKey: "clientId")
            clientId = BVSDKManager.sharedManager().clientId
        }
        
       self.apiKeyTextField.text = apiKey
       self.clientIdTextField.text = clientId
        
        self.hideStarsSwitch.on = hideStars
        self.customStarsSwitch.on = customStars
        
        self.starColorSegControl.selectedSegmentIndex = colorIndex
        
        // Check if the BVSDKManager is not yet configured
        if (BVSDKManager.sharedManager().clientId.isEmpty || BVSDKManager.sharedManager().apiKeyShopperAdvertising.isEmpty){
            
            self.errorLabel.text = "Your own API Key & Client ID are required!"
            
        } else {
            
            self.errorLabel.text = ""
        
        }
        
    }
    
    func saveSettings() -> Bool {
        
        // Check if either the apikey or client id is not yet set.
        if (self.apiKeyTextField.text?.characters.count == 0 || self.clientIdTextField.text?.characters.count == 0){
            let alert = UIAlertController(title: "Settings Error", message: "Make sure you have a valid api key and client id.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.errorLabel.text = "Your own API Key & Client ID are required!"
            
            return false;
        }
        
        var shouldReloadFromScratch = false
        
        // save settigs
        let prefs = NSUserDefaults.standardUserDefaults()
        
        prefs.setObject(self.apiKeyTextField.text, forKey: "apiKey")
        prefs.setObject(self.clientIdTextField.text, forKey:"clientId")
        prefs.setBool(self.hideStarsSwitch.on, forKey: "hidestars")
        prefs.setBool(self.customStarsSwitch.on, forKey: "customstars")
        prefs.setInteger(self.starColorSegControl.selectedSegmentIndex, forKey: "starcolorindex")
        
        // Check and see if the key or client id changed, in which case we'll want to force a data reload
        if (BVSDKManager.sharedManager().clientId != self.clientIdTextField.text ||
            BVSDKManager.sharedManager().apiKeyShopperAdvertising != self.apiKeyTextField.text) {
                shouldReloadFromScratch = true
        }
        
        BVSDKManager.sharedManager().clientId = self.clientIdTextField.text!
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = self.apiKeyTextField.text!
        
        // post notification
        NSNotificationCenter.defaultCenter().postNotificationName("settingsChanged", object: shouldReloadFromScratch)
        
        self.errorLabel.text = ""
        
        return true;
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
    
        self.apiKeyTextField.endEditing(true)
        self.clientIdTextField.endEditing(true)
        
        if (true == self.saveSettings()){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.closeSettingsMenu()
        }
        
    }
    
    static func useCustomStars() -> Bool{
        
        return NSUserDefaults.standardUserDefaults().boolForKey("customstars")
    }
    
    static func hideStars() -> Bool {
        
        return NSUserDefaults.standardUserDefaults().boolForKey("hidestars")
    }
    
    static func starColor() -> UIColor {
        
        let index = NSUserDefaults.standardUserDefaults().integerForKey("starcolorindex")
        
        if index == 0 {
            return UIColor(red: 1.0, green: 0.73, blue: 0.04, alpha: 1.0) // yellow
        } else {
            return UIColor(red: 0.10, green: 0.76, blue: 0.03, alpha: 1.0) // green
        }
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
