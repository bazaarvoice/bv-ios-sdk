//
//  StoreLocationTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FontAwesomeKit

class StoreLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var addressLine1Label: UILabel!
    
    @IBOutlet weak var addressLine2Label: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var selectedIcon: UIImageView!
    
    var storeLocation : StoreLocation! {
        
        didSet {
            self.storeNameLabel.text = storeLocation!.storeName
            self.addressLine1Label.text = storeLocation!.storeAddress
            self.addressLine2Label.text = "\(storeLocation!.storeCity)" + "," + " \(storeLocation!.storeState)" + " " +  "\(storeLocation!.storeZip)"
            self.phoneNumberLabel.text = storeLocation!.storeTel
            self.hoursLabel.text = "10am - 9pm"
            if storeLocation.distainceInMilesFromCurrentLocation > 0 {
                self.distanceLabel.text = String(format: "(%.1f mi)", storeLocation.distainceInMilesFromCurrentLocation!)
            } else {
                self.distanceLabel.text = ""
            }
            
            
            self.setCheckOff()
        }
        
    }
    
    func setCheckOff(){
        self.selectedIcon.image = Util.getFontAwesomeIconImage(FAKFontAwesome.circleOIconWithSize)
    }
    
    func setCheckOn(){
        
        self.selectedIcon.image = Util.getFontAwesomeIconImage(FAKFontAwesome.checkCircleOIconWithSize, color: UIColor.bazaarvoiceTeal(), alpha: 1.0, size: 20)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
