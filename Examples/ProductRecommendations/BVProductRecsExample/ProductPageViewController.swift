//
//  ProductPageViewController.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSDK
import NVActivityIndicatorView

class ProductPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var product: BVProduct?
    
    var selectedCategoryId : String?
    
    var categoryIds : [String]?
    
    @IBOutlet weak var categoryPickerButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var recommendationsInSameCategoryView : BVProductRecommendationsCollectionView!
    @IBOutlet weak var recommendationsBasedOnProductView : BVProductRecommendationsCollectionView!
    
    var spinner1 = Util.createSpinner()
    var spinner2 = Util.createSpinner()
    
    var errorLabel1 = Util.createErrorLabel()
    var errorLabel2 = Util.createErrorLabel()
    
    var recommendationsBasedOnProduct : [BVProduct]?
    var recommendationsInSameCategory : [BVProduct]?
    
    @IBOutlet weak var recommendationStrategyLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpPopRootButton()
        
        self.productTitleLabel.text = self.product?.productName
        
        self.productImageView.sd_setImageWithURL(NSURL(string: product!.imageURL))
        
        self.categoryIds = self.product?.rawProductDict["category_ids"] as? [String]
        if (self.categoryIds!.count > 0){
            self.selectedCategoryId = self.categoryIds![0]
        } else {
            self.selectedCategoryId = nil
            self.categoryPickerButton.hidden = true
        }
        
        self.recommendationsBasedOnProductView.dataSource = self
        self.recommendationsBasedOnProductView.delegate = self
        self.recommendationsBasedOnProductView.registerNib(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        
        self.recommendationsInSameCategoryView.dataSource = self
        self.recommendationsInSameCategoryView.delegate = self
        self.recommendationsInSameCategoryView.registerNib(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        
        self.recommendationsBasedOnProductView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.recommendationsBasedOnProductView.layer.borderWidth = 0.5
        self.recommendationsBasedOnProductView.layer.cornerRadius = 4
        
        self.recommendationsInSameCategoryView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.recommendationsInSameCategoryView.layer.borderWidth = 0.5
        self.recommendationsInSameCategoryView.layer.cornerRadius = 4
        
        self.loadRecommendationsSimilarToProduct()
        self.loadRecommendationsInSameCategory()

    }
    
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        // set the item size for the collection views
        for carousel in [ self.recommendationsInSameCategoryView, self.recommendationsBasedOnProductView ] {
            
            let layout = (carousel?.collectionViewLayout) as! UICollectionViewFlowLayout
            layout.itemSize = CGSizeMake((carousel?.bounds.height)!, (carousel?.bounds.height)!)
            
        }
        
        self.spinner1.center = self.recommendationsBasedOnProductView.center
        self.spinner2.center = self.recommendationsInSameCategoryView.center
        
    }
    
    func loadRecommendationsSimilarToProduct() {
        
        // show activity spinner
        self.view.addSubview(self.spinner1)
        self.errorLabel1.removeFromSuperview()
        
        let productId = self.product!.productId
        
        let request = BVRecommendationsRequest(limit: 10, withProductId: productId)
        self.recommendationsBasedOnProductView.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
        
            self.spinner1.removeFromSuperview()
            self.recommendationsBasedOnProduct = recommendations
            self.recommendationsBasedOnProductView.reloadData()
            
        }) { (error:NSError) in
            
            self.spinner1.removeFromSuperview()
            self.errorLabel1.frame = self.recommendationsBasedOnProductView.bounds
            self.recommendationsBasedOnProductView.addSubview(self.errorLabel1)
            
        }
        
    }
    
    func loadRecommendationsInSameCategory() {
        
        // show activity spinner
        self.view.addSubview(self.spinner2)
        self.errorLabel2.removeFromSuperview()
        
        let categoryId = self.selectedCategoryId ?? ""
        
        let loader = BVRecommendationsLoader()
        loader.loadRequest(BVRecommendationsRequest(limit: 10, withCategoryId: categoryId), completionHandler: { (recommendations:[BVProduct]) in
            
            self.spinner2.removeFromSuperview()
            self.recommendationsInSameCategory = recommendations
            self.recommendationsInSameCategoryView.reloadData()
            
        }) { (error:NSError) in
            
            self.spinner2.removeFromSuperview()
            self.errorLabel2.frame = self.recommendationsInSameCategoryView.bounds
            self.recommendationsInSameCategoryView.addSubview(self.errorLabel2)
            
        }
        
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
    
    
    @IBAction func selectCategory(sender: AnyObject) {
        
        // let user pick what category to limit the recommendations to
        let optionMenu = UIAlertController(title: nil, message: "Select a category filter.", preferredStyle: .ActionSheet)
        
        let closure = { (action: UIAlertAction!) -> Void in let
            
            index = optionMenu.actions.indexOf(action)
            
            if index != nil {
                
                self.selectedCategoryId = self.categoryIds![index!]
                
                self.loadRecommendationsInSameCategory()
                
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
    
    //MARK: UICollectionViewDelegate & UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.recommendationsInSameCategoryView {
            return self.recommendationsInSameCategory?.count ?? 0
        }
        else {
            return self.recommendationsBasedOnProduct?.count ?? 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCarouselCollectionViewCell", forIndexPath: indexPath) as! DemoCarouselCollectionViewCell
        
        var product : BVProduct?
        
        if collectionView == self.recommendationsInSameCategoryView {
            product = self.recommendationsInSameCategory![indexPath.row]
        }
        
        if collectionView == self.recommendationsBasedOnProductView {
            product = self.recommendationsBasedOnProduct![indexPath.row]
        }
        
        cell.bvProduct = product!
        cell.productName.text = product!.productName
        cell.rating.text = "\(product!.averageRating ?? 0)"
        cell.numReview.text = "(\(product!.numReviews ?? 0) reviews)"
        cell.price.text = product!.price ?? ""
        cell.starRating.value = CGFloat(product!.averageRating.floatValue)
        
        let imageUrl = NSURL(string: product!.imageURL)
        cell.productImageView.sd_setImageWithURL(imageUrl)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var product : BVProduct?
        
        if collectionView == self.recommendationsInSameCategoryView {
            product = self.recommendationsInSameCategory![indexPath.row]
        }
        
        if collectionView == self.recommendationsBasedOnProductView {
            product = self.recommendationsBasedOnProduct![indexPath.row]
        }
        
        let productView = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productView.title = product!.productName
        productView.product = product!
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productView, animated: true)
        
    }
    
}
