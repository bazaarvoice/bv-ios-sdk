//
//  LocationCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FontAwesomeKit

class LocationCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView?
    @IBOutlet private weak var textLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView?.image = Util.getFontAwesomeIconImage(FAKFontAwesome.mapMarkerIcon(withSize:))
        
        if let defaultCachedStore = LocationPreferenceUtils.getDefaultStore() {
            textLbl?.text = "My Store: " + defaultCachedStore.city + ", " + defaultCachedStore.state
        } else {
            textLbl?.text = "Set your default store location!"
        }
        
        textLbl?.textColor = UIColor.bazaarvoiceNavy()

    }

}
