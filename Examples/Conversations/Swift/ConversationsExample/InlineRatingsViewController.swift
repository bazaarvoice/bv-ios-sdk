//
//  InlineRatingsViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class InlineRatingsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var inlineReviewsTableView: UITableView!

    var productStatistics = [BVProductStatistics]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inlineReviewsTableView.dataSource = self
        inlineReviewsTableView.estimatedRowHeight = 68
        inlineReviewsTableView.rowHeight = UITableViewAutomaticDimension
        inlineReviewsTableView.registerNib(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
        
        let productIds = ["test1", "test2","test3", "test4", "test5", "test6"]
        
        let reviews = BVBulkRatingsRequest(productIds: productIds, statistics: BulkRatingsStatsType.All)
        
        reviews.load({ (response) in
                self.productStatistics = response.results
                self.inlineReviewsTableView.reloadData()
            }) { (error) in
                print(error)
        }
        
    }

    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Inline Review Responses"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productStatistics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StatisticTableViewCell")! as! StatisticTableViewCell
                
        cell.statTypeLabel.text = "Product Id: " + productStatistics[indexPath.row].productId!
        cell.statValueLabel.text = "Total Review Count(\(productStatistics[indexPath.row].reviewStatistics!.totalReviewCount!.stringValue)), \nAverage Overall Rating(\(productStatistics[indexPath.row].reviewStatistics!.averageOverallRating!.stringValue)), \nOverall Rating Range(\(productStatistics[indexPath.row].reviewStatistics!.overallRatingRange!.stringValue)) "
        
        return cell
    }

    
   
}
