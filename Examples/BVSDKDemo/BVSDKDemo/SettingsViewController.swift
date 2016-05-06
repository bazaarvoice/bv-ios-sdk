//
//  SettingsViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedRowIndex = -1
    
    func createTextField(placeholder: String) -> UITextField {
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 3
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        textField.leftViewMode = .Always
        return textField
        
    }
    
    lazy var clientTableView : UITableView = {
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
        
    }()
    
    lazy var mockExplanationLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center
        label.textColor = UIColor.bazaarvoiceNavy()
        label.text = "We'll show fake, but good looking data to show how the whole app works.\n\n Click 'client' to show live client's data."
        return label
        
    }()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        showClientInput()
        
        self.title = "Demo Client Settings"
        
    }
    
    
    func showClientInput() {
        
        self.mockExplanationLabel.removeFromSuperview()
        self.view.addSubview(self.clientTableView)
        
    }
    
    func showMockView() {
        
        self.clientTableView.removeFromSuperview()
        self.view.addSubview(self.mockExplanationLabel)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let paddingX = self.view.bounds.width / 8
        let leftX = paddingX
        let width = self.view.bounds.width - paddingX*2
        
        clientTableView.frame = CGRect(
            x: leftX,
            y: 26,
            width: width,
            height: self.view.bounds.height - 40
        )
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 + (DemoConfigManager.configs?.count ?? 0)
        
    }
    
    func getConfiguredProductsString(config: DemoConfig) -> String {
        
        var strings:[String] = []
        
        if config.shopperAdvertisingKey != "REPLACE_ME" {
            strings.append("Recommendations, Advertising")
        }
        if config.curationsKey != "REPLACE_ME" {
            strings.append("Curations")
        }
        if config.conversationsKey != "REPLACE_ME" {
            strings.append("Conversations")
        }
        
        return strings.joinWithSeparator(", ")
        
    }
    
    func setMockData()  {
        
        BVSDKManager.sharedManager().clientId = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyConversations = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyCurations = "REPLACE_ME"
        
    }
    
    let reuseIdentifier = "settingsViewCell"
    
    func shouldMock() -> Bool {
        
        let sdk = BVSDKManager.sharedManager()
        let curations = sdk.apiKeyCurations == "" || sdk.apiKeyCurations == "REPLACE_ME"
        let conversations = sdk.apiKeyConversations == "" || sdk.apiKeyConversations == "REPLACE_ME"
        let recommendations = sdk.apiKeyShopperAdvertising == "" || sdk.apiKeyShopperAdvertising == "REPLACE_ME"
        
        return  curations && conversations && recommendations
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) ??
                   UITableViewCell(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        cell.accessoryType = .None
        
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "Use all mock data"
            cell.detailTextLabel?.text = "Recommendations, Advertising, Curations, Conversations"
            
            if shouldMock() {
                cell.accessoryType = .Checkmark
            }
            
        }
        else {
        
            let config = DemoConfigManager.configs![indexPath.row-1]
            
            cell.textLabel?.text = config.clientId
            cell.detailTextLabel?.text = getConfiguredProductsString(config)
            if isCurrentlySelected(config) {
                cell.accessoryType = .Checkmark
            }
            
        }
        
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        
        return cell
        
    }
    
    func isCurrentlySelected(config: DemoConfig) -> Bool {
        
        return BVSDKManager.sharedManager().clientId == config.clientId
            && BVSDKManager.sharedManager().apiKeyShopperAdvertising == config.shopperAdvertisingKey
            && BVSDKManager.sharedManager().apiKeyConversations == config.conversationsKey
            && BVSDKManager.sharedManager().apiKeyCurations == config.curationsKey
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedConfigDisplayName : String? = nil
        
        if indexPath.row == 0 {
            self.setMockData()
        }
        else {
        
            let config = DemoConfigManager.configs?[indexPath.row-1]
            
            /// read keys from file (for BV development).
            /// If key is "REPLACE_ME", app with show demo data.
            BVSDKManager.sharedManager().clientId = config!.clientId
            BVSDKManager.sharedManager().apiKeyShopperAdvertising = config!.shopperAdvertisingKey
            BVSDKManager.sharedManager().apiKeyConversations = config!.conversationsKey
            BVSDKManager.sharedManager().apiKeyCurations = config!.curationsKey
            
            selectedConfigDisplayName = config!.displayName
            
        }
        
        let defaults = NSUserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo")
        defaults!.setObject(selectedConfigDisplayName, forKey: MockDataManager.PRESELECTED_CONFIG_DISPLAY_NAME_KEY)
        defaults!.synchronize()
        
        self.clientTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.clientTableView.reloadRowsAtIndexPaths(
            self.clientTableView.indexPathsForVisibleRows!,
            withRowAnimation: .Automatic)
        
    }

}
