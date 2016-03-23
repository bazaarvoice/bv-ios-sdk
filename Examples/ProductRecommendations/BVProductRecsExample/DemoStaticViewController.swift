//
//  StaticViewController.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

import UIKit
import BVSDK
import SDWebImage

class DemoStaticViewController: UIViewController {
    
    @IBOutlet weak var recommendationsContainerView : BVProductRecommendationsContainer!
    var recommendations : [BVProduct]?
    var spinner = Util.createSpinner()
    var errorLabel = Util.createErrorLabel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.loadRecommendations()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.spinner.center = self.recommendationsContainerView.center
        
    }
    
    func loadRecommendations() {
        
        // add loading icon
        self.view.addSubview(self.spinner)
        self.errorLabel.removeFromSuperview()
        
        let request = BVRecommendationsRequest(limit:4)
        self.recommendationsContainerView.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            // remove loading icon
            
            self.spinner.removeFromSuperview()
            self.recommendations = recommendations
            self.showRecommendations()
            
        }) { (error:NSError) in
            
            self.spinner.removeFromSuperview()
            self.errorLabel.frame = self.recommendationsContainerView.bounds
            self.view.addSubview(self.errorLabel)
            print("Error: \(error.localizedDescription)")
                
        }
        
        
    }
    
    func showRecommendations() {
        
        let numRecommendations = CGFloat(self.recommendations!.count)
        
        let bounds = recommendationsContainerView?.bounds
        
        var productBounds = CGRectMake((bounds?.origin.x)!, (bounds?.origin.y)!, (bounds?.width)!, (bounds?.height)! / numRecommendations)
        
        for product in self.recommendations! {
            
            let productView = NSBundle.mainBundle().loadNibNamed("DemoStaticProductView", owner: self, options: nil).first as! DemoStaticProductView
            
            productView.bvProduct = product
            
            productView.frame = productBounds
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "viewTap:")
            tapGesture.cancelsTouchesInView = false
            productView.addGestureRecognizer(tapGesture)
            
            self.recommendationsContainerView?.addSubview(productView)
            
            productBounds.origin.y += productBounds.height
            
        }
        
    }
    
    func viewTap(sender: UITapGestureRecognizer) {

        let productView = sender.view as! DemoStaticProductView
        let product = productView.bvProduct
        product.recordTap()

        let productDetailPage = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productDetailPage.title = product.productName
        productDetailPage.product = product
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productDetailPage, animated: true)
        
    }

}