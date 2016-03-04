//
//  CarouselViewController.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

class DemoCarouselViewController: UIViewController, BVRecommendationsUIDelegate, BVRecommendationsUIDataSource {
    
    @IBOutlet weak var descriptionLabel : UILabel?
    @IBOutlet weak var carouselView : BVRecommendationsCarouselView?
    @IBOutlet weak var carouselViewHeight : NSLayoutConstraint?
    var starColor = UIColor.blackColor()
    var starsHidden = false
    var useCustomStars = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        carouselView?.layer.borderWidth = 0.5
        carouselView?.layer.cornerRadius = 4;
        
        carouselView?.cellHorizontalSpacing = 8;
        carouselView?.leftAndRightPadding = 8;
        carouselView?.topAndBottmPadding = 8;
        
        carouselView?.delegate = self;
        carouselView?.datasource = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadOnSettingsChange:", name: "settingsChanged", object: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func reloadOnSettingsChange(notification:NSNotification){
        
        if (notification.object?.boolValue == true){
            carouselView?.reloadView()
        } else {
            carouselView?.refreshView()
        }
        
    }
    
    @IBAction func CarouselHeightSliderChangedValue(sender: UISlider) {
        carouselViewHeight?.constant = CGFloat(sender.value)
        carouselView?.reloadView()
    }
    

    //MARK: - BVRecommendationsUIDelegate
    
    func styleRecommendationsView(recommendationsView: BVRecommendationsSharedView!) {
        
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
        // example delegate method
        print("didFailToLoadWithError: called from CarouselViewController. \(err.localizedDescription)")
    }
    
    func didLoadUserRecommendations(profileRecommendations: BVShopperProfile!) {
        // example delegate method
        
    }
    
}