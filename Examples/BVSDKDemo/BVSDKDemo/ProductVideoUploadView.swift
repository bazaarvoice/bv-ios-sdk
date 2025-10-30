//
//  ProductVideoUploadView.swift
//  BVSDKDemo
//
//  Created by Rahul on 28/10/25.
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//

protocol ProductVideoUploadViewDelegate: AnyObject {
    func openVideoPicker()
}

class ProductVideoUploadView: UIView {
    @IBOutlet weak var addVideoButton: UIButton!
    
    var delegate : ProductVideoUploadViewDelegate?
    
    @IBAction func addVideoButtonPressed(_ sender: Any) {
        delegate?.openVideoPicker()
    }
}
