//
//  PINCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class PINCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var productSelected: ((BVPIN) -> Void)?
    
    @IBOutlet private weak var collectionView: UICollectionView?
    var productsToReview: [BVPIN]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView?.register(UINib(nibName: "PinCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PinCarouselCollectionViewCell")
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsToReview?.count ?? 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinCarouselCollectionViewCell", for: indexPath) as! PinCarouselCollectionViewCell
        cell.pin = productsToReview![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width * 0.4
        return CGSize(width: w, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let _ = productSelected {
            productSelected!(productsToReview![indexPath.row])
        }
    }
}
