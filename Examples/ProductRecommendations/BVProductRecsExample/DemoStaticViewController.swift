//
//  StaticViewController.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

class DemoStaticViewController: UIViewController, BVRecommendationsUIDelegate {
    
    @IBOutlet weak var staticView : BVRecommendationsStaticView?

    override func viewDidLoad() {
        super.viewDidLoad()
        staticView?.configureNumberOfRecommendations(3)
        staticView?.cellPadding = 5
        staticView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        staticView?.layer.borderWidth = 0.5
        staticView?.layer.cornerRadius = 5
        staticView?.delegate = self
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
        print("styleRecommendationsView")
    }
    
    func didSelectProduct(product: BVProduct!) {
        print("didSelectProduct \(product.name)")
    }
    
    func didFailToLoadWithError(err: NSError!) {
        print("didFailToLoadWithError called from DemoStaticViewController. \(err.localizedDescription)");
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

}
