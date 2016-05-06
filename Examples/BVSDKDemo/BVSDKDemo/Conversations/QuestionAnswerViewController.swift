//
//  QuestionAnswerViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import FontAwesomeKit

class QuestionAnswerViewController: BaseUGCViewController, BVDelegate {
    
    var questions : [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Questions"
        
        let nib1 = UINib(nibName: "CallToActionCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "CallToActionCell")
        
        let nib2 = UINib(nibName: "QuestionAnswerTableViewCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "QuestionAnswerTableViewCell")
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // add a Ask a question button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask a question", style: .Plain, target: self, action: "askQuestionTapped")
        
        self.loadQuestions()
        
    }
    
    func loadQuestions() {
        
        let get = BVGet(type: BVGetTypeQuestions)
        get.setFilterForAttribute("ProductId", equality: BVEqualityEqualTo, value: product.productId)
        get.addInclude(BVIncludeTypeAnswers)
        get.limit = 20
        get.sendRequestWithDelegate(self)
        
    }
    
    func askQuestionTapped() {
        
        let askAQuestionVC = AskAQuestionViewController(nibName: "AskAQuestionViewController", bundle: nil, product: product)
        
        self.navigationController?.pushViewController(askAQuestionVC, animated: true)
        
    }
    
    func submitAnswerPressed(sender: UIButton) {
        
        let indexPathSection = sender.tag
        let question = questions[indexPathSection]
        
        let vc = SubmitAnswerViewController(nibName: "SubmitAnswerViewController", bundle: nil, product: product, question: question)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func readAnswersTapped(sender: UIButton) {
        
        let indexPathSection = sender.tag
        let question = questions[indexPathSection]
        
        let vc = AnswersViewController(nibName: "AnswersViewController", bundle: nil, product: product, question: question)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: BVDelegate
    
    func didReceiveResponse(response: [NSObject : AnyObject]!, forRequest request: AnyObject!) {
        
        self.spinner.removeFromSuperview()
        
        questions = ConversationsResponse<Question>(apiResponse: response).results
        self.tableView.reloadData()
        
    }
    
    // MARK: UITableViewDatasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     
        return questions.count
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.min
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let question = questions[indexPath.section]
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("QuestionAnswerTableViewCell") as! QuestionAnswerTableViewCell
            cell.question = question
            return cell
            
        }
        else {
            
            let callToActionCell = tableView.dequeueReusableCellWithIdentifier("CallToActionCell") as! CallToActionCell
            callToActionCell.setCustomRightIcon(FAKFontAwesome.chevronRightIconWithSize)
            
            let numAnswers = question.answers.count
            if numAnswers == 0 {
                callToActionCell.button.setTitle("Be the first to answer!", forState: .Normal)
                callToActionCell.setCustomLeftIcon(FAKFontAwesome.plusIconWithSize)
                callToActionCell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                callToActionCell.button.tag = indexPath.section
                callToActionCell.button.addTarget(self, action: "submitAnswerPressed:", forControlEvents: .TouchUpInside)
            }
            else {
                callToActionCell.button.setTitle("Read \(numAnswers) answers", forState: .Normal)
                callToActionCell.setCustomLeftIcon(FAKFontAwesome.commentsIconWithSize)
                callToActionCell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                callToActionCell.button.tag = indexPath.section
                callToActionCell.button.addTarget(self, action: "readAnswersTapped:", forControlEvents: .TouchUpInside)
            }
            
            return callToActionCell
            
        }
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}
