//
//  ProfileViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var facebookProfile : NSDictionary = [String : String]()
    var customTargeting : NSDictionary = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Profile"
        
        facebookProfile = ProfileUtils.sharedInstance.loginProfile
        
        customTargeting = BVSDKManager.sharedManager().getCustomTargeting()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LOG OUT", style: .Done, target: self, action: "logoutTapped")
        
    }

    internal func logoutTapped(){
        
        ProfileUtils.sharedInstance.logOut()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    internal func getInterests() -> [String]{
        if let interests = self.customTargeting["interests"] {
            let s = interests as! String
            return s.componentsSeparatedByString(" ")
        } else {
            return []
        }
    }
    
    internal func getBrands() -> [String]{
        if let brands = self.customTargeting["brands"] {
            let s = brands as! String
            return s.componentsSeparatedByString(" ")
        } else {
            return []
        }
    }
    
    
    
    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Profile Info"
        } else if section == 1 {
            return "Inerests"
        } else if section == 2 {
            return "Brands"
        }
        
        return ""
        
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view.isKindOfClass(UITableViewHeaderFooterView)) {
            let headerView = view as! UITableViewHeaderFooterView
            
            // Label
            headerView.textLabel!.textColor = UIColor.whiteColor()
            headerView.contentView.backgroundColor = UIColor.bazaarvoiceNavy()
            
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return self.facebookProfile.count
            
        case 1:
            return getInterests().count
            
        case 2:
            return getBrands().count
            
        default:
                return 0
            
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ??
            UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
        if indexPath.section == 0 {
            let sortedKeys = (facebookProfile.allKeys as! [String]).sort(<)
            let key = sortedKeys[indexPath.row]
            
            cell.textLabel?.text = sortedKeys[indexPath.row]
            cell.detailTextLabel?.text = facebookProfile[key] as? String
        }
        else if indexPath.section == 1 {
            
            let interest = getInterests()[indexPath.row]
            cell.textLabel!.text = interest
            
        }
        else if indexPath.section == 2 {
            
            let brand = getBrands()[indexPath.row]
            cell.textLabel!.text = brand
            
        }
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    
    
}
