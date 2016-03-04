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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadOnSettingsChange:", name: "settingsChanged", object: nil)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableViewController!.view.frame = self.view.bounds
    }
    
    func reloadOnSettingsChange(notification:NSNotification){
        
        if (notification.object?.boolValue == true){
            tableViewController?.reloadView()
        } else {
            tableViewController?.refreshView()
        }
        
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
        
        // Optionally, style the product view
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // example delegate method
        recommendationsView.starsAndReviewStatsHidden = appDelegate.hideStars()
        recommendationsView.starsColor = appDelegate.starsColor()
        
        if appDelegate.useCustomStars(){
            recommendationsView.starsEmptyImage = UIImage(named: "like-unselected.png")
            recommendationsView.starsFilledImage = UIImage(named: "heart-filled.png")
        } else {
            recommendationsView.starsEmptyImage = nil
            recommendationsView.starsFilledImage = nil
        }    }
    
    func didSelectProduct(product: BVProduct!) {
        
        // Navigate to a demo produdct page
        
        let productView = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productView.title = product.productName
        productView.product = product
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productView, animated: true)
    }
    
    func didFailToLoadWithError(err: NSError!) {
        print("didFailToLoadWithError called from RecommendationTableViewController. \(err.localizedDescription)");
    }
    
    func didToggleLike(product: BVProduct!) {
        print("didToggleLike for \(product.productName)");
    }
    
    func didToggleDislike(product: BVProduct!) {
        print("didTogggleBan for \(product.productName)")
    }
    
    func didSelectShopNow(product: BVProduct!) {
        print("didSelectShopNow for \(product.productName)")
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

