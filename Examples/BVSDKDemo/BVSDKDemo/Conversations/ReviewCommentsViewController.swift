//
//  ReviewCommentsViewController.swift
//  BVSDKDemo
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ReviewCommentsViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var commentsTableView: UITableView!
  
  let comments : [BVComment]
  
  init(reviewComments : [BVComment]) {
    
    self.comments = reviewComments
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.commentsTableView.dataSource = self
    self.title = "Review Comments"
    
    commentsTableView.estimatedRowHeight = 60
    commentsTableView.rowHeight = UITableViewAutomaticDimension
    commentsTableView.allowsSelection = false
    
    let nib = UINib(nibName: "ReviewCommentTableViewCell", bundle: nil)
    commentsTableView.register(nib, forCellReuseIdentifier: "ReviewCommentTableViewCell")
    
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.comments.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCommentTableViewCell") as! ReviewCommentTableViewCell
    
    cell.comment = self.comments[indexPath.row]
    
    cell.onAuthorNickNameTapped = { (authorId) -> Void in
      let authorVC = AuthorProfileViewController(authorId: authorId)
      self.navigationController?.pushViewController(authorVC, animated: true)
    }
    
    
    return cell
  }
  
  
  
  
}
