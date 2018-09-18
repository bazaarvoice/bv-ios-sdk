//
//  ViewController.swift
//  CurationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//
import UIKit
import BVSDK
import SDWebImage

class ViewController: UIViewController, BVCurationsUICollectionViewDelegate {
  
  @IBOutlet weak var curationsCollectionView: BVCurationsUICollectionView?
  @IBOutlet weak var stepper: UIStepper?
  
  @IBOutlet var heightConstraintGrid: NSLayoutConstraint!
  @IBOutlet var heightConstraintCarousel: NSLayoutConstraint!
  
  let sdMngr = SDWebImageManager.shared()
  let numRowsStart: UInt = 2
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up the Curations UI display properties
    curationsCollectionView?.curationsDelegate = self
    curationsCollectionView?.groups = ["__all__"]
    curationsCollectionView?.fetchSize = 60
    curationsCollectionView?.infiniteScrollEnabled = true
    curationsCollectionView?.itemsPerRow = numRowsStart
    curationsCollectionView?.bvCurationsUILayout = .grid
    curationsCollectionView?.loadFeed()
    
    curationsCollectionView?.backgroundColor = UIColor.lightGray
    stepper?.value = Double(numRowsStart)
  }
  
  @IBAction func updateRowCount(_ sender: UIStepper) {
    if (sender.value > 0) {
      if (curationsCollectionView?.bvCurationsUILayout == .carousel) {
        curationsCollectionView?.bvCurationsUILayout = .grid
        self.heightConstraintGrid.isActive = true
        heightConstraintCarousel.isActive = false
      }
      curationsCollectionView?.itemsPerRow = UInt(sender.value)
    }else {
      curationsCollectionView?.bvCurationsUILayout = .carousel
      heightConstraintGrid.isActive = false
      heightConstraintCarousel.isActive = true
      view.layoutIfNeeded()
    }
    
    view.layoutIfNeeded()
  }
  
  // MARK: BVCurationsUICollectionViewDelegate
  
  
  func curationsLoadImage(_ imageUrl: String, completion:@escaping BVSDK.BVCurationsLoadImageCompletion) {
    self.loadImage(imageUrl, completion: completion)
  }
  
  func curationsImageIsCached(_ imageUrl: String, completion:@escaping BVCurationsIsImageCachedCompletion) {
    
    self.sdMngr.cachedImageExists(for: URL(string: imageUrl)) { (cached) in
      completion(cached, imageUrl)
    }
    
  }
  
  func curationsDidSelect(_ feedItem: BVCurationsFeedItem) {
    print("Tapped: " + feedItem.debugDescription)
  }
  
  func curationsFailed(toLoadFeed error: Error) {
    print("An error occurred: " + error.localizedDescription)
  }
  
  fileprivate func loadImage(_ imageUrl: String, completion:@escaping ((UIImage, String) -> Void)) {
    
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
