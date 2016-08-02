//
//  RatingsAndReviewsViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class RatingsAndReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: BVReviewsTableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSizeMake(44,44), padding: 0)
    
    let product : BVRecommendedProduct
    var reviews : [BVReview] = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product:BVRecommendedProduct) {
        self.product = product
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Reviews"
        
        ProfileUtils.trackViewController(self)
        
        header.product = product
        
        self.view.backgroundColor = UIColor.appBackground()
        self.tableView.backgroundColor = self.view.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingTableViewCell")
        
        // add a Write Review button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Write a review", style: .Plain, target: self, action: "writeReviewTapped")
        
        self.loadReviews()
        
    }
    
    func loadReviews() {

        let request = BVReviewsRequest(productId: product.productId, limit: 20, offset: 0)
        
        self.tableView.load(request, success: { (response) in
            
            self.spinner.removeFromSuperview()
            self.reviews = response.results
            self.tableView.reloadData()
            
            })
        { (errors) in
            
            print("An error occurred: \(errors)")
            
        }
        
    }
    
    // MARK - overriden from BaseUGCViewController
    
    func writeReviewTapped() {
        
        let vc = WriteReviewViewController(nibName:"WriteReviewViewController", bundle: nil, product: product)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: UITableViewDatasource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RatingTableViewCell") as! RatingTableViewCell
        
        cell.review = reviews[indexPath.row]
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Currently nothing to do when selecting a review
        // But we could add further review author details (e.g. profile view)
        return;
        
    }

}
