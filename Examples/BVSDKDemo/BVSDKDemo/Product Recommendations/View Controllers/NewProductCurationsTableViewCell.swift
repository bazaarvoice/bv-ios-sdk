//
//  NewProductCurationsTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
import UIKit
import BVSDK
import FontAwesomeKit
import SDWebImage

class NewProductCurationsTableViewCell: UITableViewCell, BVCurationsUICollectionViewDelegate {
  
  @IBOutlet weak var curationsCarousel : BVCurationsUICollectionView!
  @IBOutlet weak var errorLabel : UILabel! // initially hidden
  
    let sdMngr = SDWebImageManager.shared
  
  var product : BVProduct? {
    
    didSet {
      if let product = product {
        self.curationsCarousel.curationsDelegate = self
        self.curationsCarousel.groups = ["__all__"]
        self.curationsCarousel.productId = product.identifier
        self.curationsCarousel.bvCurationsUILayout = .carousel
        self.curationsCarousel.loadFeed()
      }
    }
  }
  
  var onFeedItemTapped : ((_ selectedIndex : NSInteger, _ fullFeed: [BVCurationsFeedItem]) -> Void)? = nil
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let layout = (curationsCarousel?.collectionViewLayout) as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: (curationsCarousel?.bounds.height)!, height: (curationsCarousel?.bounds.height)!)
    
  }
  
  public func curationsLoadImage(_ imageUrl: String, completion: @escaping BVSDK.BVCurationsLoadImageCompletion) {
    self.loadImage(imageUrl: imageUrl, completion: completion)
    
  }
  
  public func curationsImageIsCached(_ imageUrl: String, completion: @escaping BVSDK.BVCurationsIsImageCachedCompletion) {
    let key = self.sdMngr.cacheKey(for: URL(string: imageUrl))
    self.sdMngr.imageCache.containsImage(forKey: key, cacheType: SDImageCacheType.all, completion: { (containsCacheType) in
        let cached = containsCacheType != SDImageCacheType.none
        completion(cached, imageUrl)
        })
  }
  
  public func curationsDidSelect(_ feedItem: BVCurationsFeedItem) {
    if let tapped = onFeedItemTapped {
      let idx = curationsCarousel.feedItems.index(of: feedItem)!
      tapped(idx, curationsCarousel.feedItems)
    }
  }
  
  private func loadImage(imageUrl: String, completion:@escaping ((UIImage, String) -> Void)) {
    
    _ = self.sdMngr.loadImage(with: URL(string: imageUrl)!,
                              options: [],
                              progress: { (_, _, _) in
                                
    }, completed: { (image, _, _, _, _, url) in
      if let img = image {
        completion(img, imageUrl)
      }
    })
    
  }
}
