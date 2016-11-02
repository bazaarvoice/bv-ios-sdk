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
    
    var facebookProfile : NSDictionary = [String : String]() as NSDictionary
    var customTargeting : NSDictionary = [String : String]() as NSDictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Profile"
        
        facebookProfile = ProfileUtils.sharedInstance.loginProfile as NSDictionary
        
        customTargeting = BVSDKManager.shared().getCustomTargeting() as NSDictionary
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LOG OUT", style: .done, target: self, action: #selector(ProfileViewController.logoutTapped))
        
    }

    internal func logoutTapped(){
        
        ProfileUtils.sharedInstance.logOut()
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    internal func getInterests() -> [String]{
        if let interests = self.customTargeting["interests"] {
            let s = interests as! String
            return s.components(separatedBy: " ")
        } else {
            return []
        }
    }
    
    internal func getBrands() -> [String]{
        if let brands = self.customTargeting["brands"] {
            let s = brands as! String
            return s.components(separatedBy: " ")
        } else {
            return []
        }
    }
    
    
    
    // MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Profile Info"
        } else if section == 1 {
            return "Inerests"
        } else if section == 2 {
            return "Brands"
        }
        
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view.isKind(of: UITableViewHeaderFooterView.self)) {
            let headerView = view as! UITableViewHeaderFooterView
            
            // Label
            headerView.textLabel!.textColor = UIColor.white
            headerView.contentView.backgroundColor = UIColor.bazaarvoiceNavy()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ??
            UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        if (indexPath as NSIndexPath).section == 0 {
            let sortedKeys = (facebookProfile.allKeys as! [String]).sorted(by: <)
            let key = sortedKeys[(indexPath as NSIndexPath).row]
            
            cell.textLabel?.text = sortedKeys[(indexPath as NSIndexPath).row]
            cell.detailTextLabel?.text = facebookProfile[key] as? String
        }
        else if (indexPath as NSIndexPath).section == 1 {
            
            let interest = getInterests()[(indexPath as NSIndexPath).row]
            cell.textLabel!.text = interest
            
        }
        else if (indexPath as NSIndexPath).section == 2 {
            
            let brand = getBrands()[(indexPath as NSIndexPath).row]
            cell.textLabel!.text = brand
            
        }
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    
    
}
