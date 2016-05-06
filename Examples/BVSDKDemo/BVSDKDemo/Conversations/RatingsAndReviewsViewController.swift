//
//  RatingsAndReviewsViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class RatingsAndReviewsViewController: BaseUGCViewController, BVDelegate {

    var reviews : [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RatingTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "RatingTableViewCell")
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        // add a Write Review button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Write a review", style: .Plain, target: self, action: "writeReviewTapped")
        
        self.title = "Reviews"
        
        self.loadReviews()
        
    }
    
    func loadReviews() {
        
        let get = BVGet(type: BVGetTypeReviews)
        get.setFilterForAttribute("ProductId", equality: BVEqualityEqualTo, value: product.productId)
        get.addInclude(BVIncludeTypeProducts)
        get.addStatsOn(BVIncludeStatsTypeReviews)
        get.limit = 20
        get.sendRequestWithDelegate(self)
        
    }
    
    // MARK: BVDelegate
    
    func didReceiveResponse(response: [NSObject : AnyObject]!, forRequest request: AnyObject!) {
        
        self.spinner.removeFromSuperview()
        
        reviews = ConversationsResponse<Review>(apiResponse: response).results
        
        tableView.reloadData()
        
    }
    
    // MARK - overriden from BaseUGCViewController
    
    func writeReviewTapped() {
        
        let vc = WriteReviewViewController(nibName:"WriteReviewViewController", bundle: nil, product: product)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: UITableViewDatasource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count
        
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
