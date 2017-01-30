//
//  ViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK


class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var reviewsTableView : BVReviewsTableView!
    var reviews : [BVReview] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTableView.dataSource = self
        reviewsTableView.estimatedRowHeight = 44
        reviewsTableView.rowHeight = UITableViewAutomaticDimension
        reviewsTableView.registerNib(UINib(nibName: "MyReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableViewCell")
        
        let reviewsRequest = BVReviewsRequest(productId: "test1", limit: 20, offset: 0)
        reviewsRequest.addReviewSort(.SubmissionTime, order: .Descending)
        
        reviewsTableView.load(reviewsRequest, success: { (response) in
            
            self.reviews = response.results
            self.reviewsTableView.reloadData()
            
            }) { (error) in
                
            print(error)
                
        }
        
    }
    
    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Review Responses"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCellWithIdentifier("MyReviewTableViewCell") as! MyReviewTableViewCell
        
        tableCell.review = reviews[indexPath.row]
        
        return tableCell
    }

}
