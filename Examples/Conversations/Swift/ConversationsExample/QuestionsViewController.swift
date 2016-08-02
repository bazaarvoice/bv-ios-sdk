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
        questionsTableView.registerNib(UINib(nibName: "MyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyQuestionTableViewCell")
        
        let questionsRequest = BVQuestionsAndAnswersRequest(productId: "test1", limit: 20, offset: 0)
        
        self.questionsTableView.load(questionsRequest, success: { (response) in
            
            self.questions = response.results
            self.questionsTableView.reloadData()
            
            }) { (error) in
                
            print(error)
                
        }
            
    }

    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Question Responses"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyQuestionTableViewCell")! as! MyQuestionTableViewCell
        
        cell.question = questions[indexPath.row];
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get the answers for this question
        let question = questions[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let answersVC = storyboard.instantiateViewControllerWithIdentifier("AnswersViewController") as! AnswersViewController
        answersVC.question = question
        self.navigationController?.pushViewController(answersVC, animated: true)
        
    }

}
