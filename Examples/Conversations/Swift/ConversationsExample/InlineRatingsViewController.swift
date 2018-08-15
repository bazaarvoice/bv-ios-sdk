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
    inlineReviewsTableView.register(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
    
    let reviews = BVBulkRatingsRequest(productIds: Constants.TEST_PRODUCT_IDS_ARRAY, statistics: .bulkRatingAll)
    
    reviews.load({ (response) in
      self.productStatistics = response.results
      self.inlineReviewsTableView.reloadData()
    }) { (error) in
      print(error)
    }
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Inline Review Responses"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return productStatistics.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell")! as! StatisticTableViewCell
    
    cell.statTypeLabel.text = "Product Id: " + productStatistics[indexPath.row].productId!
    cell.statValueLabel.text = "Total Review Count(\(productStatistics[indexPath.row].reviewStatistics!.totalReviewCount!.stringValue)), \nAverage Overall Rating(\(productStatistics[indexPath.row].reviewStatistics!.averageOverallRating!.stringValue)), \nOverall Rating Range(\(productStatistics[indexPath.row].reviewStatistics!.overallRatingRange!.stringValue)) "
    
    return cell
  }
}
