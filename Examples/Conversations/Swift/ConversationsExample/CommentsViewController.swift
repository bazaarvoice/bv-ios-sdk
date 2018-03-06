//
//  CommentsViewController.swift
//  
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class CommentsViewController: UIViewController, UITableViewDataSource {
  
  
  @IBOutlet weak var commentsTaleView: UITableView!
  var comments : [BVComment] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    commentsTaleView.dataSource = self
    commentsTaleView.estimatedRowHeight = 44
    commentsTaleView.rowHeight = UITableViewAutomaticDimension
    commentsTaleView.register(UINib(nibName: "MyCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCommentTableViewCell")
    
    let limit : UInt16  = 99
    let offset : UInt16 = 0
    let request = BVCommentsRequest(productId: Constants.TEST_REVIEW_PRODUCT_ID_FOR_COMMENTS, andReviewId: Constants.TEST_REVIEW_ID_FOR_COMMENTS, limit: limit, offset: offset)
    
    request.load({ (response) in
      
      self.comments = response.results
      self.commentsTaleView.reloadData()
      
    }) { (error) in
      
      print("ERROR fetching comments: \(error.first!.localizedDescription)")
      
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Available Comments"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let tableCell = tableView.dequeueReusableCell(withIdentifier: "MyCommentTableViewCell") as! MyCommentTableViewCell
    
    tableCell.comment = comments[indexPath.row]
    
    return tableCell
  }
  
  
  
}
