//
//  StoreLocationTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FontAwesomeKit
import BVSDK
import HCSStarRatingView

class StoreLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var addressLine1Label: UILabel!
    
    @IBOutlet weak var addressLine2Label: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var selectedIcon: UIImageView!
    
    @IBOutlet weak var starRating: HCSStarRatingView!
    
    @IBOutlet weak var numReviewsLabel: UILabel!
    
    var onNumReviewsLabelTapped : ((_ store : BVStore) -> Void)? = nil
    
    var store : BVStore! {
        
        didSet {
            self.storeNameLabel.text = store.name
            self.addressLine1Label.text = store.storeLocation?.address
            
            if store!.storeLocation!.city != nil && store!.storeLocation!.state != nil && store!.storeLocation!.postalcode != nil {
                self.addressLine2Label.text = "\(store!.storeLocation!.city!)" + "," + " \(store!.storeLocation!.state!)" + " " +  "\(store!.storeLocation!.postalcode!)"
                self.hoursLabel.text = "10am - 9pm"
            } else {
                self.addressLine2Label.text = ""
                self.hoursLabel.text = ""
            }
            
            var ratingValue : CGFloat = 0.0
            if store.reviewStatistics?.averageOverallRating != nil {
                ratingValue = CGFloat((store.reviewStatistics?.averageOverallRating?.floatValue)!)
            }
            
            self.starRating.value =  ratingValue
            self.numReviewsLabel.text = "(\(store.reviewStatistics!.totalReviewCount!.intValue))"
            self.numReviewsLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StoreLocationTableViewCell.didTapNumReviewsLabel(_:)))
            self.numReviewsLabel.addGestureRecognizer(tapGesture)
            
            if store.storeLocation!.phone != nil {
                self.phoneNumberLabel.text = store.storeLocation!.phone
            } else {
                self.phoneNumberLabel.text = ""
            }
            
            if store.distanceInMetersFromCurrentLocation() > 0.0 {
                self.distanceLabel.text = String(format: "(%.1f mi)", store.distanceInMetersFromCurrentLocation()/1609.344)
            } else {
                self.distanceLabel.text = ""
            }
            
            self.setCheckOff()
        }
        
    }
    
    @IBAction func tappedReviewsHotSpot(_ sender: AnyObject) {
        onNumReviewsLabelTapped!(self.store)
    }
    
    
    func didTapNumReviewsLabel(_ sender: UITapGestureRecognizer)
    {
        if self.onNumReviewsLabelTapped != nil {
            onNumReviewsLabelTapped!(self.store)
        }
    }
    
    func setCheckOff(){
        self.selectedIcon.image = Util.getFontAwesomeIconImage(FAKFontAwesome.circleOIcon(withSize:))
    }
    
    func setCheckOn(){
        
        self.selectedIcon.image = Util.getFontAwesomeIconImage(FAKFontAwesome.checkCircleOIcon(withSize:), color: UIColor.bazaarvoiceTeal(), alpha: 1.0, size: 20)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
