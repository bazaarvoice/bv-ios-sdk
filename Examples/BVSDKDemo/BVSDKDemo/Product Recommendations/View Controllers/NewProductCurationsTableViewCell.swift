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
            requestParams.withProductData = true
            requestParams.externalId = product?.productId
            
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
            
            self.curationsCarousel.loadFeedWithRequest(requestParams, withWidgetId: nil, completionHandler: { (feedItemsResult) -> Void in
                
                self.curationsFeed = feedItemsResult
                self.curationsCarousel.reloadData()
                
                if self.curationsFeed == nil || self.curationsFeed!.count == 0  {
                    self.errorLabel.hidden = false
                    self.errorLabel.text = "No social content to show - upload your own!"
                }
                else {
                    self.errorLabel.hidden = true
                }
                
                
            }) { (error) -> Void in
                
                self.errorLabel.text = "An error occurred"
                self.errorLabel.hidden = false
                
            }
            
        }
        
    }
    
    var onFeedItemTapped : ((selectedIndex : NSInteger, fullFeed: [BVCurationsFeedItem]) -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.curationsCarousel.registerNib(UINib(nibName: "DemoCurationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCurationsCollectionViewCell")
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = (curationsCarousel?.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake((curationsCarousel?.bounds.height)!, (curationsCarousel?.bounds.height)!)
        
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let curationFeed = self.curationsFeed else {
            return 0
        }
        
        return curationFeed.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCurationsCollectionViewCell", forIndexPath: indexPath) as! DemoCurationsCollectionViewCell
        
        cell.feedItem = self.curationsFeed![indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let onFeedItemCellTapped = self.onFeedItemTapped {
            onFeedItemCellTapped(selectedIndex: indexPath.row, fullFeed: self.curationsFeed!)
        }

    }

    
}
