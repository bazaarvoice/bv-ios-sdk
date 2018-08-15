//
//  QuestionsViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class QuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var questionsTableView : BVQuestionsTableView!
  var questions : [BVQuestion] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    questionsTableView.dataSource = self
    questionsTableView.delegate = self
    questionsTableView.estimatedRowHeight = 80
    questionsTableView.rowHeight = UITableViewAutomaticDimension
    questionsTableView.register(UINib(nibName: "MyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyQuestionTableViewCell")
    
    let questionsRequest = BVQuestionsAndAnswersRequest(productId: Constants.TEST_PRODUCT_ID, limit: 20, offset: 0)
    
    // optionally add in a sort option
    questionsRequest.sort(by: .questionSubmissionTime, monotonicSortOrderValue: .ascending)
    // optionally add in a filter
    questionsRequest.filter(on: .questionHasAnswers, relationalFilterOperatorValue: .equalTo, value: "true")
    
    self.questionsTableView.load(questionsRequest, success: { (response) in
      
      self.questions = response.results
      self.questionsTableView.reloadData()
      
    }) { (error) in
      
      print(error)
      
    }
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Question Responses"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionTableViewCell")! as! MyQuestionTableViewCell
    
    cell.question = questions[indexPath.row];
    
    return cell
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Get the answers for this question
    let question = questions[indexPath.row]
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let answersVC = storyboard.instantiateViewController(withIdentifier: "AnswersViewController") as! AnswersViewController
    answersVC.question = question
    self.navigationController?.pushViewController(answersVC, animated: true)
  }
}
