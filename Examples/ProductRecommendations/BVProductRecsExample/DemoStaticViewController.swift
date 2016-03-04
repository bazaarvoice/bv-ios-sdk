//
//  StaticViewController.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

class DemoStaticViewController: UIViewController, BVRecommendationsUIDelegate, BVRecommendationsUIDataSource {
    
    @IBOutlet weak var staticView : BVRecommendationsStaticView?

    override func viewDidLoad() {
        super.viewDidLoad()
        staticView?.recommendationSettings.recommendationLimit = 3;
        staticView?.cellPadding = 5
        staticView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        staticView?.layer.borderWidth = 0.5
        staticView?.layer.cornerRadius = 5
        staticView?.delegate = self
        staticView?.datasource = self // kicks off the API call
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadOnSettingsChange:", name: "settingsChanged", object: nil)

    }
    
    func reloadOnSettingsChange(notification:NSNotification){
        
        if (notification.object?.boolValue == true){
            staticView?.reloadView()
        } else {
            staticView?.refreshView()
        }
    
    }
    
    //MARK: BVRecommendationsUIDelegate
    
    
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
        }
    }
    
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
        print("didFailToLoadWithError called from DemoStaticViewController. \(err.localizedDescription)");
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

}
