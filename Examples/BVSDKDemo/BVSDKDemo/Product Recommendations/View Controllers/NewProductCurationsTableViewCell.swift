//
//  NewProductCurationsTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import FontAwesomeKit

class NewProductCurationsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var curationsCarousel : BVCurationsCollectionView!
    @IBOutlet weak var errorLabel : UILabel! // initially hidden
    
    var curationsFeed : [BVCurationsFeedItem]?
    
    var product : BVRecommendedProduct? {
        
        didSet {
            
            let requestParams = BVCurationsFeedRequest(groups: ["__all__"]);
            requestParams?.withProductData = true
            requestParams?.externalId = product?.productId
            
            // Check and see if we can get Lat/Long from a default store set
            // If so, we can make the feed results send the results closest to 
            // the provided coordinates first.
            /*
            if let defaultStore = LocationPreferenceUtils.getDefaultStore(){
                if defaultStore.latitude != nil && defaultStore.longitude != nil {
                    let lat = Double(defaultStore.latitude)
                    let long = Double(defaultStore.longitude)
                    requestParams.setLatitude(lat!, longitude: long!)
                }
            }
             */
            
            self.curationsCarousel.delegate = self
            self.curationsCarousel.dataSource = self
            
            self.curationsCarousel.loadFeed(with: requestParams!, withWidgetId: nil, completionHandler: { (feedItemsResult) -> Void in
                
                self.curationsFeed = feedItemsResult
                self.curationsCarousel.reloadData()
                
                if self.curationsFeed == nil || self.curationsFeed!.count == 0  {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "No social content to show - upload your own!"
                }
                else {
                    self.errorLabel.isHidden = true
                }
                
                
            }) { (error) -> Void in
                
                self.errorLabel.text = "An error occurred"
                self.errorLabel.isHidden = false
                
            }
            
        }
        
    }
    
    var onFeedItemTapped : ((_ selectedIndex : NSInteger, _ fullFeed: [BVCurationsFeedItem]) -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.curationsCarousel.register(UINib(nibName: "DemoCurationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCurationsCollectionViewCell")
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = (curationsCarousel?.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (curationsCarousel?.bounds.height)!, height: (curationsCarousel?.bounds.height)!)
        
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let curationFeed = self.curationsFeed else {
            return 0
        }
        
        return curationFeed.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCurationsCollectionViewCell", for: indexPath) as! DemoCurationsCollectionViewCell
        
        cell.feedItem = self.curationsFeed![(indexPath as NSIndexPath).row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let onFeedItemCellTapped = self.onFeedItemTapped {
            onFeedItemCellTapped((indexPath as NSIndexPath).row, self.curationsFeed!)
        }

    }

    
}
