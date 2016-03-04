//
//  ProductPageViewController.swift
//  BVProductRecsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation

class ProductPageViewController: UIViewController, BVRecommendationsUIDelegate, BVRecommendationsUIDataSource {
    
    var product: BVProduct?
    
    var selectedCategoryId : String?
    
    var categoryIds : [String]?
    
    @IBOutlet weak var categoryPickerButton: UIButton!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var recommendationCarouselMixerStrategy: BVRecommendationsCarouselView!
    @IBOutlet weak var recommendationCarouselCategory: BVRecommendationsCarouselView!
    
    @IBOutlet weak var recommendationStrategyLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpPopRootButton()
        
        self.productTitleLabel.text = self.product?.productName
        
        self.productImageView.sd_setImageWithURL(NSURL(string: product!.imageURL))
        
        // configure the recommendations by strategy carousel
        
        // Mixer strategy carousel ------------------
        
        self.categoryIds = self.product?.rawProductDict["category_ids"] as! [String]
        if (self.categoryIds!.count > 0){
            self.selectedCategoryId = self.categoryIds![0]
        } else {
            self.selectedCategoryId = nil
            self.categoryPickerButton.hidden = true
        }
        
        recommendationCarouselMixerStrategy?.layer.borderColor = UIColor.lightGrayColor().CGColor
        recommendationCarouselMixerStrategy?.layer.borderWidth = 0.5
        recommendationCarouselMixerStrategy?.layer.cornerRadius = 4
        
        recommendationCarouselMixerStrategy?.cellHorizontalSpacing = 8
        recommendationCarouselMixerStrategy?.leftAndRightPadding = 8
        recommendationCarouselMixerStrategy?.topAndBottmPadding = 8
        
        // recommendations view data properties
        recommendationCarouselMixerStrategy?.recommendationSettings.productId = self.product?.productId
        recommendationCarouselMixerStrategy?.recommendationSettings.maxAgeCache = 30
        
        recommendationCarouselMixerStrategy.delegate = self
        
        // Category carousel ---------------------
        
        recommendationCarouselCategory?.layer.borderColor = UIColor.lightGrayColor().CGColor
        recommendationCarouselCategory?.layer.borderWidth = 0.5
        recommendationCarouselCategory?.layer.cornerRadius = 4
        
        recommendationCarouselCategory?.cellHorizontalSpacing = 8
        recommendationCarouselCategory?.leftAndRightPadding = 8
        recommendationCarouselCategory?.topAndBottmPadding = 8
        
        // recommendations view data properties
        recommendationCarouselCategory?.recommendationSettings.productId = nil
        recommendationCarouselCategory?.recommendationSettings.categoryId = self.selectedCategoryId
        recommendationCarouselCategory?.recommendationSettings.maxAgeCache = 30
        
        recommendationCarouselCategory.delegate = self
        
        self.reloadCategoryCarousel()
        self.reloadMixerStrategyCarousel()

    }
    
    func setUpPopRootButton(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        
        if (rootViewController.viewControllers.count > 2){
                        
            let barButtonItem : UIBarButtonItem = UIBarButtonItem(title: "HOME", style: .Plain, target: self, action:"popRoot")
            self.navigationItem.rightBarButtonItem = barButtonItem
            
        }
        
    }
    
    func popRoot(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.popToRootViewControllerAnimated(true)
        
    }
    
    func reloadMixerStrategyCarousel(){
        
        recommendationCarouselMixerStrategy.datasource = self
    }
    
    func reloadCategoryCarousel(){
        
        recommendationCarouselCategory.datasource = self
    }
    
    
    @IBAction func selectCategory(sender: AnyObject) {
        
        doCategoryPicker()
    }
    
    
    
    func doCategoryPicker(){
        
        let optionMenu = UIAlertController(title: nil, message: "Select a category filter.", preferredStyle: .ActionSheet)
        
        let closure = { (action: UIAlertAction!) -> Void in let
            
            index = optionMenu.actions.indexOf(action)
            
            if index != nil {
                
                self.selectedCategoryId = self.categoryIds![index!]
                
                self.recommendationCarouselCategory.recommendationSettings.categoryId = self.selectedCategoryId
                
                self.reloadCategoryCarousel()
                
            }
        }
        
        for prodId in self.categoryIds! as [String] {
            optionMenu.addAction(UIAlertAction(title: prodId, style: .Default, handler: closure))
        }
        
        optionMenu.addAction(UIAlertAction(title:"Cancel", style: .Cancel, handler: nil))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            optionMenu.modalPresentationStyle = .Popover
            let popover = optionMenu.popoverPresentationController!
            popover.permittedArrowDirections = .Up
            popover.sourceView = self.categoryPickerButton
            popover.sourceRect = self.categoryPickerButton.bounds
        }
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    //MARK: -  BVRecommendationsUIDelegate
    
    func styleRecommendationsView(recommendationsView: BVRecommendationsSharedView!) {
        
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
        //
        let productView = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productView.title = product.productName
        productView.product = product
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productView, animated: true)
        
    }
    
    func didFailToLoadWithError(err: NSError!) {
        // error
        
    }
    
    //MARK: -  BVRecommendationsUIDatasource
    
}
