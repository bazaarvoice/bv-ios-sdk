//
//  NewProductRecsTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import GoogleMobileAds

class NewProductRecsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, GADNativeContentAdLoaderDelegate {
    
    @IBOutlet weak var recommendationsCarousel: BVProductRecommendationsCollectionView!
    
    var products : [BVRecommendedProduct]?
    
    var adLoader : GADAdLoader?
    var nativeContentAd : GADNativeContentAd?
    
    let specialAdIndex = 4
    
    var referenceProduct : BVRecommendedProduct? {
        
        didSet {
            
            let request = BVRecommendationsRequest.init(limit: 20, withProductId: self.referenceProduct!.productId)
            
            recommendationsCarousel.delegate = self
            recommendationsCarousel.dataSource = self
            
            recommendationsCarousel.loadRequest(request, completionHandler: { (products) -> Void in
                print("Loaded recommendations: " + products.description)
                self.products = products
                self.recommendationsCarousel.reloadData()
                
                }) { (ErrorType) -> Void in
                    print("Error loading recs.")
            }

            
        }
        
    }
    
    var onProductRecTapped : ((selectedProduct : BVRecommendedProduct) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
        self.recommendationsCarousel.registerNib(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        self.recommendationsCarousel.registerNib(UINib(nibName: "NewNativeAdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewNativeAdCollectionViewCell")
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = (recommendationsCarousel?.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake((recommendationsCarousel?.bounds.height)!, (recommendationsCarousel?.bounds.height)!)
        
    }
    
    var parentViewController : UIViewController? {
        didSet{
            self.loadAd(parentViewController!)
        }
    }
    
    func loadAd(parentViewController: UIViewController) {
        
        adLoader = GADAdLoader(
            adUnitID: "/5705/bv-incubator/EnduranceCyclesSale",
            rootViewController: parentViewController,
            adTypes: [ kGADAdLoaderAdTypeNativeContent ],
            options: nil
        )
        adLoader!.delegate = self
        
        let request = DFPRequest()
        request.customTargeting = BVSDKManager.sharedManager().getCustomTargeting()
        adLoader!.loadRequest(request)
        
    }
        
    //MARK: UICollectionViewDelegate & UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let products = self.products {
            if nativeContentAd == nil {
                return products.count
            }
            else {
                return products.count + 1
            }
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        var index = indexPath.row
        
        if nativeContentAd != nil && index == specialAdIndex {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewNativeAdCollectionViewCell", forIndexPath: indexPath) as! NewNativeAdCollectionViewCell
            
            cell.nativeContentAd = nativeContentAd
            
            return cell
        }
        
        if nativeContentAd != nil && index >= specialAdIndex {
            index -= 1
        }
        
        let product = self.products![index]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCarouselCollectionViewCell", forIndexPath: indexPath) as! DemoCarouselCollectionViewCell
        
        // TODO: This shold be set in the cell itself...not here...
        cell.bvRecommendedProduct = product
        cell.productName.text = product.productName
        cell.price.text = product.price ?? ""
        cell.starRating.value = CGFloat(product.averageRating.floatValue)
        
        let imageUrl = NSURL(string: product.imageURL)
        cell.productImageView.sd_setImageWithURL(imageUrl)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if nativeContentAd != nil && indexPath.row == specialAdIndex {
            return;
        }
        else {
            
            var index = indexPath.row
            
            if nativeContentAd != nil && index >= specialAdIndex {
                index -= 1
            }
            
            let product = self.products![index]
            
            if let onProductRecTapped = self.onProductRecTapped {
                onProductRecTapped(selectedProduct: product)
            }
        }
        
    }
    
    //MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(adLoader: GADAdLoader!, didReceiveNativeContentAd nativeContentAd: GADNativeContentAd!) {
        
        self.nativeContentAd = nativeContentAd
        self.recommendationsCarousel.reloadData()
        
    }
    
    func adLoader(adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {

        print("failed to load ad: \(error)")
        
    }
    
}
