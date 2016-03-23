//
//  CarouselViewController.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

import UIKit
import BVSDK
import SDWebImage

class DemoCarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var recommendations:[BVProduct]?
    
    @IBOutlet weak var descriptionLabel : UILabel?
    @IBOutlet weak var carouselView : BVProductRecommendationsCollectionView!
    @IBOutlet weak var carouselViewHeightConstraint : NSLayoutConstraint!
    
    var spinner = Util.createSpinner()
    var errorLabel = Util.createErrorLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.layer.borderColor = UIColor.lightGrayColor().CGColor
        carouselView.layer.borderWidth = 0.5
        carouselView.layer.cornerRadius = 4
        
        carouselView.dataSource = self
        carouselView.delegate = self
        
        carouselView.registerNib(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        
        self.loadRecommendations()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        if self.view.bounds.size.height <= 500 {
            self.descriptionLabel!.text = ""
        }
        
        let layout = (carouselView.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(carouselView.bounds.height, carouselView.bounds.height)
        
        self.spinner.center = self.carouselView.center
        
    }
    
    func loadRecommendations() {
        
        // add loading icon
        self.view.addSubview(self.spinner)
        self.errorLabel.removeFromSuperview()
        
        let request = BVRecommendationsRequest(limit: 20)
        self.carouselView.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.recommendations = recommendations
            self.carouselView?.reloadData()
            
        }) { (error:NSError) in
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.errorLabel.frame = self.carouselView.bounds
            self.carouselView.addSubview(self.errorLabel)
            print("Error: \(error.localizedDescription)")
            
        }

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.recommendations?.count ?? 0
        
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCarouselCollectionViewCell", forIndexPath: indexPath) as! DemoCarouselCollectionViewCell
        
        let product = self.recommendations![indexPath.row]
        
        cell.bvProduct = product
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let product = self.recommendations![indexPath.row]
        
        let productView = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productView.title = product.productName
        productView.product = product
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productView, animated: true)
        
    }
    
    @IBAction func carouselHeightChanged(sender: UISlider) {
        
        self.carouselViewHeightConstraint.constant = CGFloat(sender.value)
        
    }
    
}