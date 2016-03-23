//
//  DemoTableViewController.swift
//  BVProductRecsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class DemoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : BVProductRecommendationsTableView!
    
    var recommendations:[BVProduct]?
    
    var spinner = Util.createSpinner()
    
    var errorLabel = Util.createErrorLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 300
        
        self.loadRecommendations()
        
        self.tableView.registerNib(UINib(nibName: "DemoTableViewCell", bundle: nil), forCellReuseIdentifier: "DemoTableViewCell")

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.spinner.center = self.view.center
        
    }
    
    func loadRecommendations() {
        
        self.view.addSubview(self.spinner)
        self.errorLabel.removeFromSuperview()
        
        let profile = BVGetShopperProfile()
        profile.fetchProductRecommendations(20) { (profile:BVShopperProfile?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.spinner.removeFromSuperview()
                
                if error != nil {
                    
                    self.errorLabel.frame = self.view.bounds
                    self.view.addSubview(self.errorLabel)
                    print("Error: \(error!.localizedDescription)")
                    
                }
                else {
                    
                    self.recommendations = profile?.recommendations as? [BVProduct]
                    self.tableView.reloadData()
                    
                }
                
            })
            
        }
        
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendations?.count ?? 0;
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("DemoTableViewCell", forIndexPath: indexPath) as! DemoTableViewCell
        
        let product = self.recommendations![indexPath.row]
        
        cell.bvProduct = product
        cell.productName.text = product.productName
        cell.rating.text = "\(product.averageRating ?? 0)"
        cell.numReview.text = "(\(product.numReviews ?? 0) reviews)"
        cell.starRating.value = CGFloat(product.averageRating.floatValue)
        cell.productReview.text = product.review.reviewText
        cell.author.text = product.review.reviewAuthorName
        cell.selectionStyle = .None
        
        let imageUrl = NSURL(string: product.imageURL)
        cell.productImageView?.sd_setImageWithURL(imageUrl)

        return cell
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let product = self.recommendations![indexPath.row]
        
        let productView = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productView.title = product.productName
        productView.product = product
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productView, animated: true)
        
    }
    
}
