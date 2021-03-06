//
//  AuthorProfileViewController.swift
//  BVSDKDemo
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

enum TableViewTag : Int {
  case ReviewsTableView = 0, QuestionsTableView, AnswersTableView, ReviewCommentsTableView
}

class AuthorProfileViewController: UIViewController, UITableViewDataSource {
  
  var authorId : String?
  var author : BVAuthor?
  
  var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
  
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userLocationLabel: UILabel!
  @IBOutlet weak var userBadgesLabel: UILabel!
  
  @IBOutlet weak var ugcTypeSegmentedControl: UISegmentedControl!
  
  @IBOutlet weak var reviewsTableView: UITableView!
  @IBOutlet weak var questionsTableView: UITableView!
  @IBOutlet weak var answersTableView: UITableView!
  @IBOutlet weak var commentsTableView: UITableView!
  
  init(authorId : String) {
    
    self.authorId = authorId
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Profile"
    
    let nib1 = UINib(nibName: "RatingTableViewCell", bundle: nil)
    reviewsTableView.register(nib1, forCellReuseIdentifier: "RatingTableViewCell")
    reviewsTableView.estimatedRowHeight = 40
    reviewsTableView.rowHeight = UITableView.automaticDimension
    reviewsTableView.allowsSelection = false
    
    let nib2 = UINib(nibName: "AnswerTableViewCell", bundle: nil)
    answersTableView.register(nib2, forCellReuseIdentifier: "AnswerTableViewCell")
    answersTableView.estimatedRowHeight = 40
    answersTableView.rowHeight = UITableView.automaticDimension
    answersTableView.allowsSelection = false
    
    let nib3 = UINib(nibName: "QuestionAnswerTableViewCell", bundle: nil)
    questionsTableView.register(nib3, forCellReuseIdentifier: "QuestionAnswerTableViewCell")
    questionsTableView.estimatedRowHeight = 40
    questionsTableView.rowHeight = UITableView.automaticDimension
    questionsTableView.allowsSelection = false
    
    let nib4 = UINib(nibName: "ReviewCommentTableViewCell", bundle: nil)
    commentsTableView.register(nib4, forCellReuseIdentifier: "ReviewCommentTableViewCell")
    commentsTableView.estimatedRowHeight = 40
    commentsTableView.rowHeight = UITableView.automaticDimension
    commentsTableView.allowsSelection = false
    
    self.view.layoutIfNeeded()
    self.initDefaultUI()
    self.fetchAuthorProfile()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.spinner.center = self.view.center
  }
  
  private func initDefaultUI() {
    
    self.view.bringSubviewToFront(self.reviewsTableView)
    
    self.userNameLabel.text = ""
    self.userLocationLabel.text = ""
    self.userBadgesLabel.text = ""
    
    self.userBadgesLabel.layer.cornerRadius = 2
    self.userBadgesLabel.layer.backgroundColor = UIColor.bazaarvoiceTeal().cgColor
    
    // round the profile image
    self.userProfileImageView.setRounded()
    
  }
  
  private func fetchAuthorProfile(){
    
    self.reviewsTableView.addSubview(self.spinner)
    
    let request = BVAuthorRequest(authorId: self.authorId!)
    // stats includes
    request.includeStatistics(.authorAnswers)
    request.includeStatistics(.authorQuestions)
    request.includeStatistics(.authorReviews)
    // other includes
    request.include(.authorReviews, limit: 20)
    request.include(.authorQuestions, limit: 20)
    request.include(.authorAnswers, limit: 20)
    request.include(.authorReviewComments, limit: 20)
    // sorts
    request.sort(by: .answerSubmissionTime, monotonicSortOrderValue: .descending)
    request.sort(by: .reviewSubmissionTime, monotonicSortOrderValue: .descending)
    request.sort(by: .questionSubmissionTime, monotonicSortOrderValue: .descending)
    
    request.load({ (response) in
      
      self.spinner.removeFromSuperview()
      
      // success
      if response.results.isEmpty {
        _ = SweetAlert().showAlert("Empty Profile", subTitle:"There was no profile found.", style: .error)
        return
      }
      
      self.author = response.results.first!
      
      self.userNameLabel.text = self.author?.userNickname
      
      let location = self.author?.userLocation != nil ? (self.author?.userLocation)! : ""
      self.userLocationLabel.text = location
      
      // Just adding badge text here, really we want to use an image
      var badgeString = ""
      for badge in (self.author?.badges)! {
        badgeString += badge.identifier!.uppercased()
        if !(badge.isEqual(self.author?.badges.last)) {
          badgeString += ", "
        } else {
          badgeString = " " + badgeString + " "
        }
      }
      self.userBadgesLabel.text = badgeString
      
      let totalReviewCount  = self.author?.reviewStatistics?.totalReviewCount?.intValue
      let totalQuestionCount = self.author?.qaStatistics?.totalQuestionCount?.intValue
      let totalAnswerCount = self.author?.qaStatistics?.totalAnswerCount?.intValue
      let totalCommentCount = self.author!.includedComments.count
      
      let reviewButtonText = "Reviews (\(totalReviewCount!))"
      let questionButtonText = "Questions (\(totalQuestionCount!))"
      let answerButtonText = "Answers (\(totalAnswerCount!))"
      let commentButtonText = "Comments (\(totalCommentCount))"
      
      self.ugcTypeSegmentedControl.setTitle(reviewButtonText, forSegmentAt: 0)
      self.ugcTypeSegmentedControl.setTitle(questionButtonText, forSegmentAt: 1)
      self.ugcTypeSegmentedControl.setTitle(answerButtonText, forSegmentAt: 2)
      self.ugcTypeSegmentedControl.setTitle(commentButtonText, forSegmentAt: 3)
      
      self.reviewsTableView.reloadData()
      self.questionsTableView.reloadData()
      self.answersTableView.reloadData()
      self.commentsTableView.reloadData()
      
    }) { (error) in
      
      // error
      print(error)
      _ = SweetAlert().showAlert("Error Loading Profile", subTitle: error.description, style: .error)
      self.spinner.removeFromSuperview()
      
    }
    
  }
  
  // MARK: UITableViewDatasource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if self.author == nil {
      return 0
    }
    
    switch tableView.tag {
    case TableViewTag.ReviewsTableView.rawValue:
      return (self.author?.includedReviews.count)!
    case TableViewTag.QuestionsTableView.rawValue:
      return (self.author?.includedQuestions.count)!
    case TableViewTag.AnswersTableView.rawValue:
      return (self.author?.includedAnswers.count)!
    case TableViewTag.ReviewCommentsTableView.rawValue:
      return (self.author?.includedComments.count)!
    default:
      print("Bad TableView Tag Id in numberOfRowsInSection")
    }
    
    return 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch tableView.tag {
    case TableViewTag.ReviewsTableView.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
      cell.review = self.author?.includedReviews[indexPath.row]
      return cell
    case TableViewTag.QuestionsTableView.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerTableViewCell") as! QuestionAnswerTableViewCell
      cell.question = self.author?.includedQuestions[indexPath.row]
      return cell
    case TableViewTag.AnswersTableView.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell") as! AnswerTableViewCell
      cell.answer = self.author?.includedAnswers[indexPath.row]
      return cell
    case TableViewTag.ReviewCommentsTableView.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCommentTableViewCell") as! ReviewCommentTableViewCell
      cell.comment = self.author?.includedComments[indexPath.row]
      return cell
    default:
      print("Bad TableView Tag Id in cellForRowAt")
    }
    
    return UITableViewCell()
  }
  
  // MARK: IBAction
  @IBAction func ugcSegmentToggled(_ sender: AnyObject) {
    
    switch sender.selectedSegmentIndex {
      
    case TableViewTag.ReviewsTableView.rawValue:
        self.view.bringSubviewToFront(self.reviewsTableView)
    case TableViewTag.QuestionsTableView.rawValue:
        self.view.bringSubviewToFront(self.questionsTableView)
    case TableViewTag.AnswersTableView.rawValue:
        self.view.bringSubviewToFront(self.answersTableView)
    case TableViewTag.ReviewCommentsTableView.rawValue:
        self.view.bringSubviewToFront(self.commentsTableView)
    default:
      print("Bad index in segmented control")
    }
    
  }
}


extension UIImageView {
  
  func setRounded() {
    let radius = self.frame.width/2
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
  }
}
