//
//  SearchContentCollectionViewCell.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 05/11/2019.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit

class SearchContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var btn_Radio: UIButton!
    @IBOutlet weak var lbl_Name: UILabel!
    
    var buttonData: RadioButton = RadioButton() {
        didSet {
            self.cellConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Configuration cell data
    private func cellConfiguration() {
        
        self.lbl_Name.text = ""
        self.btn_Radio.setImage(nil, for: .normal)
        
        self.lbl_Name.text = self.buttonData.buttonName
        
        if self.buttonData.isSelected {
            self.btn_Radio.setImage(.remove, for: .normal)
        }
        else {
            self.btn_Radio.setImage(.checkmark, for: .normal)
        }
    }
    
}
