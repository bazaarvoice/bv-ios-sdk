//
//  ViewController.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

class DemoTableViewController: UIViewController, BVRecommendationsUIDelegate, BVRecommendationsUIDataSource {
    
    var tableViewController:BVRecommendationsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewController = BVRecommendationsTableViewController(nibName: "BVRecommendationsTableViewController", bundle: nil)
        
        tableViewController!.delegate = self
        tableViewController!.datasource = self
        
        // add tableView as child immediately.
        // DemoTableViewController simply serves to demonstrate delegate/datasource interactions.
        addChildViewController(tableViewController!)
        view.addSubview(tableViewController!.view)
        tableViewController!.didMoveToParentViewController(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableViewController!.view.frame = self.view.bounds
    }
    
// MARK: BVRecommendationsUIDelegate
    
    func styleRecommendationsView(recommendationsView: BVRecommendationsSharedView!) {
        
        /*
         * custom style your cell here. ex:
         *
         * recommendationsView.backgroundColor = UIColor.whiteColor()
         * recommendationsView.priceHidden = true
         * recommendationsView.shopButton?.backgroundColor = UIColor.lightGrayColor()
         *
         * recommendationsView.dislikeButtonHidden = true
         * recommendationsView.likeImage = myLikeImage
         * recommendationsView.likeImageSelected = myLikeImageSelected
         *
         */
        
        recommendationsView.removeCellOnDislike = true
        
        print("styleRecommendationsView")
    }
    
    func didSelectProduct(product: BVProduct!) {
        print("didSelectProduct \(product.name)")
    }
    
    func didFailToLoadWithError(err: NSError!) {
        print("didFailToLoadWithError called from RecommendationTableViewController. \(err.localizedDescription)");
    }
    
    func didToggleLike(product: BVProduct!) {
        print("didToggleLike for \(product.name)");
    }
    
    func didToggleDislike(product: BVProduct!) {
        print("didTogggleBan for \(product.name)")
    }
    
    func didSelectShopNow(product: BVProduct!) {
        print("didSelectShopNow for \(product.name)")
    }
    
// MARK: BVRecommendationUIDatasource
    
    func setForBannedProductIds() -> NSMutableSet! {
        // Set the list of bannded product IDs on the recommendations view controller
        print("bannedProductIds")
        return NSMutableSet()
    }
    
    func setForFavoriteProductIds() -> NSMutableSet! {
        // Set the list of favorite product IDs on the recommendations view controller
        print("favoriteProductIds")
        return NSMutableSet()
    }
}

