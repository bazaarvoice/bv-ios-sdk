//
//  ViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK


class ReviewsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var reviewsTableView : BVReviewsTableView!
    var reviews : [BVReview] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTableView.dataSource = self
        reviewsTableView.estimatedRowHeight = 44
        reviewsTableView.rowHeight = UITableViewAutomaticDimension
        reviewsTableView.register(UINib(nibName: "MyReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableViewCell")
        
        let reviewsRequest = BVReviewsRequest(productId: Constants.TEST_PRODUCT_ID, limit: 20, offset: 0)
        reviewsRequest.addReviewSort(.submissionTime, order: .descending)
        
        reviewsTableView.load(reviewsRequest, success: { (response) in
            
            self.reviews = response.results
            self.reviewsTableView.reloadData()
            
            }) { (error) in
                
            print(error)
                
        }
        
    }
    
    // MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Review Responses"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell") as! MyReviewTableViewCell
        
        tableCell.review = reviews[indexPath.row]
        
        return tableCell
    }
    
}
