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
    
    func createTextField(_ placeholder: String) -> UITextField {
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 3
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        textField.leftViewMode = .always
        return textField
        
    }
    
    lazy var clientTableView : UITableView = {
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
        
    }()
    
    lazy var mockExplanationLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = UIColor.bazaarvoiceNavy()
        label.text = "We'll show fake, but good looking data to show how the whole app works.\n\n Click 'client' to show live client's data."
        return label
        
    }()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        showClientInput()
        
        self.title = "Demo Config"
        
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
        
        let paddingX = self.view.bounds.width / 32
        let leftX = paddingX
        let width = self.view.bounds.width - paddingX*2
        
        clientTableView.frame = CGRect(
            x: leftX,
            y: 26,
            width: width,
            height: self.view.bounds.height - 40
        )
        
    }
    

    func getConfiguredProductsString(_ config: DemoConfig) -> String {
        
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
        if config.conversationsStoresKey != "REPLACE_ME" {
            strings.append("Conversations Stores")
        }
        if (config.locationKey != "00000000-0000-0000-0000-000000000000"){
            strings.append("Location")
        }
        
        return strings.joined(separator: ", ")
        
    }
    
    func setMockData()  {
        
        BVSDKManager.shared().clientId = "REPLACE_ME"
        BVSDKManager.shared().apiKeyShopperAdvertising = "REPLACE_ME"
        BVSDKManager.shared().apiKeyConversations = "REPLACE_ME"
        BVSDKManager.shared().apiKeyConversationsStores = "REPLACE_ME"
        BVSDKManager.shared().apiKeyCurations = "REPLACE_ME"
        BVSDKManager.shared().apiKeyLocation = "00000000-0000-0000-0000-000000000000"
        
    }
    
    let reuseIdentifier = "settingsViewCell"
    
    func shouldMock() -> Bool {
        
        let sdk = BVSDKManager.shared()
        let curations = sdk.apiKeyCurations == "" || sdk.apiKeyCurations == "REPLACE_ME"
        let conversations = sdk.apiKeyConversations == "" || sdk.apiKeyConversations == "REPLACE_ME"
        let conversationsStores = sdk.apiKeyConversationsStores == "" || sdk.apiKeyConversationsStores == "REPLACE_ME"
        let recommendations = sdk.apiKeyShopperAdvertising == "" || sdk.apiKeyShopperAdvertising == "REPLACE_ME"
        
        return  curations && conversations && conversationsStores && recommendations
        
    }
    
    func isCurrentlySelected(_ config: DemoConfig) -> Bool {
        
        return BVSDKManager.shared().clientId == config.clientId
            && BVSDKManager.shared().apiKeyShopperAdvertising == config.shopperAdvertisingKey
            && BVSDKManager.shared().apiKeyConversations == config.conversationsKey
            && BVSDKManager.shared().apiKeyConversationsStores == config.conversationsStoresKey
            && BVSDKManager.shared().apiKeyCurations == config.curationsKey
        
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "Client Configuration Selection"
        } else if section == 1 {
            return "User Profile Details"
        }
        
        return ""
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0){
            return 1 + (DemoConfigManager.configs?.count ?? 0)
        } else if section == 1 {
            return 1;
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.numberOfLines = 0
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.accessoryType = .none
            
            if (indexPath as NSIndexPath).row == 0 {
                
                cell.textLabel?.text = "(Mock) Endurance Cycles"
                cell.detailTextLabel?.text = "Recommendations, Advertising, Curations, Conversations, Stores"
                
                if shouldMock() {
                    cell.accessoryType = .checkmark
                }
                
            }
            else {
            
                let config = DemoConfigManager.configs![(indexPath as NSIndexPath).row-1]
                
                cell.textLabel?.text = config.displayName
                cell.detailTextLabel?.text = getConfiguredProductsString(config)
                if isCurrentlySelected(config) {
                    cell.accessoryType = .checkmark
                }
                
            }
        } else if (indexPath as NSIndexPath).section == 1 {
            
            cell.textLabel?.text = "Profile"
            cell.accessoryType = .disclosureIndicator
        }
        
        
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view.isKind(of: UITableViewHeaderFooterView.self)) {
            let headerView = view as! UITableViewHeaderFooterView
            
            // Label
            headerView.textLabel!.textColor = UIColor.white
            headerView.contentView.backgroundColor = UIColor.bazaarvoiceNavy()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedConfigDisplayName : String? = nil
        
        if (indexPath as NSIndexPath).section == 0 {
            
            if (indexPath as NSIndexPath).row == 0 {
                self.setMockData()
            }
            else {
            
                let config = DemoConfigManager.configs?[(indexPath as NSIndexPath).row-1]
                
                /// read keys from file (for BV development).
                /// If key is "REPLACE_ME", app with show demo data.
                BVSDKManager.shared().clientId = config!.clientId
                BVSDKManager.shared().apiKeyShopperAdvertising = config!.shopperAdvertisingKey
                BVSDKManager.shared().apiKeyConversations = config!.conversationsKey
                BVSDKManager.shared().apiKeyConversationsStores = config!.conversationsStoresKey
                BVSDKManager.shared().apiKeyCurations = config!.curationsKey
                BVSDKManager.shared().apiKeyLocation = config!.locationKey
                
                selectedConfigDisplayName = config!.displayName
                
            }
            
            let defaults = UserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo.app")
            defaults!.set(selectedConfigDisplayName, forKey: MockDataManager.PRESELECTED_CONFIG_DISPLAY_NAME_KEY)
            defaults!.synchronize()
            
            self.clientTableView.deselectRow(at: indexPath, animated: true)
            self.clientTableView.reloadRows(
                at: self.clientTableView.indexPathsForVisibleRows!,
                with: .automatic)
        
        } else if (indexPath as NSIndexPath).section == 1 {
            
            let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }

}
