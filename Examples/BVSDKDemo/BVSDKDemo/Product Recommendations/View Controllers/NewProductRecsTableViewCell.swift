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
    
    var referenceProduct : BVProduct? {
        
        didSet {
            
            if let _ = referenceProduct {
                let request = BVRecommendationsRequest.init(limit: 20, withProductId: self.referenceProduct!.identifier)
                
                recommendationsCarousel.delegate = self
                recommendationsCarousel.dataSource = self
                
                recommendationsCarousel.load(request, completionHandler: { (products) -> Void in
                    print("Loaded recommendations: " + products.description)
                    self.products = products
                    self.recommendationsCarousel.reloadData()
                    
                }) { (ErrorType) -> Void in
                    print("Error loading recs.")
                }
            }
        }
    }
    
    var onProductRecTapped : ((_ selectedProduct : BVRecommendedProduct) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.recommendationsCarousel.register(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        self.recommendationsCarousel.register(UINib(nibName: "NewNativeAdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewNativeAdCollectionViewCell")
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = (recommendationsCarousel?.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (recommendationsCarousel?.bounds.height)!, height: (recommendationsCarousel?.bounds.height)!)
        
    }
    
    var parentViewController : UIViewController? {
        didSet{
            self.loadAd(parentViewController!)
        }
    }
    
    func loadAd(_ parentViewController: UIViewController) {
        
        adLoader = GADAdLoader(
            adUnitID: "/5705/bv-incubator/EnduranceCyclesSale",
            rootViewController: parentViewController,
            adTypes: [ kGADAdLoaderAdTypeNativeContent ],
            options: nil
        )
        adLoader!.delegate = self
        
        let request = DFPRequest()
        request.customTargeting = BVSDKManager.shared().getCustomTargeting()
        adLoader!.load(request)
        
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var index = (indexPath as NSIndexPath).row
        
        if nativeContentAd != nil && index == specialAdIndex {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewNativeAdCollectionViewCell", for: indexPath) as! NewNativeAdCollectionViewCell
            
            cell.nativeContentAd = nativeContentAd
            
            return cell
        }
        
        if nativeContentAd != nil && index >= specialAdIndex {
            index -= 1
        }
        
        let product = self.products![index]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCarouselCollectionViewCell", for: indexPath) as! DemoCarouselCollectionViewCell
        
        // TODO: This shold be set in the cell itself...not here...
        cell.bvRecommendedProduct = product
        cell.productName.text = product.productName
        cell.price.text = product.price 
        cell.starRating.value = CGFloat(product.averageRating.floatValue)
        
        let imageUrl = URL(string: product.imageURL)
        cell.productImageView.sd_setImage(with: imageUrl)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if nativeContentAd != nil && (indexPath as NSIndexPath).row == specialAdIndex {
            return;
        }
        else {
            
            var index = (indexPath as NSIndexPath).row
            
            if nativeContentAd != nil && index >= specialAdIndex {
                index -= 1
            }
            
            let product = self.products![index]
            
            if let onProductRecTapped = self.onProductRecTapped {
                onProductRecTapped(product)
            }
        }
        
    }
    
    //MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
        
        self.nativeContentAd = nativeContentAd
        self.recommendationsCarousel.reloadData()
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
}
