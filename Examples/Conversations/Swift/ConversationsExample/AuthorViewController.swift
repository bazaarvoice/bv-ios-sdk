//
//  AuthorViewController.swift
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class AuthorViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var authorProfileTableView: UITableView!
  
  var authorResponse : BVAuthorResponse?
  
  enum AuthorSections : Int {
    case ProfileStats
    case IncludedReviews
    case IncludedQuestions
    case IncludedAnswers
    
    static var count: Int { return AuthorSections.IncludedAnswers.hashValue + 1}
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    authorProfileTableView.estimatedRowHeight = 80
    authorProfileTableView.rowHeight = UITableViewAutomaticDimension
    authorProfileTableView.register(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
    authorProfileTableView.register(UINib(nibName: "MyReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableViewCell")
    authorProfileTableView.register(UINib(nibName: "MyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyQuestionTableViewCell")
    authorProfileTableView.register(UINib(nibName: "MyAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswerTableViewCell")
    
    
    let request = BVAuthorRequest(authorId: Constants.TEST_AUTHOR_ID)
    // stats includes
    request.includeStatistics(.authorAnswers)
    request.includeStatistics(.authorQuestions)
      .includeStatistics(.authorReviews)
    // other includes
    request.include(.authorReviews, limit: 10)
    request.include(.authorQuestions, limit: 10)
    request.include(.authorAnswers, limit: 10)
    // sorts
    request.sort(by: .answerSubmissionTime, monotonicSortOrderValue: .descending)
    request.sort(by: .reviewSubmissionTime, monotonicSortOrderValue: .descending)
    request.sort(by: .questionSubmissionTime, monotonicSortOrderValue: .descending)
    
    request.load({ (response) in
      
      // success
      print(response)
      self.authorResponse = response
      self.authorProfileTableView.reloadData()
      
    }) { (error) in
      
      // error
      print(error)
      
    }
  }
  
  // MARK: UITableViewDatasource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return AuthorSections.count;
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    switch section {
    case AuthorSections.ProfileStats.rawValue:
      return "Author Profile Stats"
    case AuthorSections.IncludedReviews.rawValue:
      return "Included Reviews"
    case AuthorSections.IncludedAnswers.rawValue:
      return "Included Answers"
    case AuthorSections.IncludedQuestions.rawValue:
      return "Included Questions"
    default:
      return ""
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if let author = self.authorResponse?.results.first {
      
      switch section {
      case AuthorSections.ProfileStats.rawValue:
        return 1;
      case AuthorSections.IncludedReviews.rawValue:
        return (author.includedReviews.count);
      case AuthorSections.IncludedQuestions.rawValue:
        return (author.includedQuestions.count);
      case AuthorSections.IncludedAnswers.rawValue:
        return (author.includedAnswers.count);
      default:
        return 0;
      }
    }
    else {
      print("Error: No results to display")
      return 0;
    }
  }
  
  func createAutorStats(author: BVAuthor) -> String {
    
    var result = ""
    
    result += "Stats for: " + author.userNickname! + "\n"
    
    if author.userLocation != nil {
      result += "Location: " + author.userLocation! + "\n"
    }
    
    if author.reviewStatistics != nil {
      result += "Reviews (\(author.reviewStatistics!.totalReviewCount!))" + "\n"
    }
    
    if author.qaStatistics != nil {
      result += "Questions (\(author.qaStatistics!.totalQuestionCount!))" + "\n"
      result += "Answers (\(author.qaStatistics!.totalAnswerCount!))" + "\n"
    }
    
    result += "Context Data Values: (\(author.contextDataValues.count))"
    
    for contextData in author.contextDataValues {
      result += "[" + contextData.identifier! + ":" + contextData.value! + "]"
    }
    
    result += "\n"
    
    result += "Badges (\(author.badges.count))"
    
    for badge in author.badges {
      result += "[" + badge.identifier! + ":" + badge.contentType! + "]"
    }
    
    result += "\n"
    
    return result
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let author = self.authorResponse?.results.first!
    
    switch indexPath.section {
    case AuthorSections.ProfileStats.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell")! as! StatisticTableViewCell
      cell.statTypeLabel.text = "Author Statistics";
      cell.statValueLabel.text = self.createAutorStats(author: author!)
      return cell
    case AuthorSections.IncludedReviews.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell")! as! MyReviewTableViewCell
      cell.review = author!.includedReviews[indexPath.row]
      return cell
    case AuthorSections.IncludedQuestions.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionTableViewCell")! as! MyQuestionTableViewCell
      cell.question = author!.includedQuestions[indexPath.row]
      cell.accessoryType = .none
      return cell
    case AuthorSections.IncludedAnswers.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnswerTableViewCell")! as! MyAnswerTableViewCell
      cell.answer = author!.includedAnswers[indexPath.row]
      return cell
    default:
      return UITableViewCell()
    }
  }
}
