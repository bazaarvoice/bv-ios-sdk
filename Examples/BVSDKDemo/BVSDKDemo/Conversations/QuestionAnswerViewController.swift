//
//  QuestionAnswerViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import FontAwesomeKit

class QuestionAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: BVQuestionsTableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSizeMake(44,44), padding: 0)
    let product: BVRecommendedProduct
    var questions : [BVQuestion] = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product:BVRecommendedProduct?) {
        self.product = product!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Questions"
        
        ProfileUtils.trackViewController(self)
        
        header.product = product
        
        self.view.backgroundColor = UIColor.appBackground()
        self.tableView.backgroundColor = UIColor.appBackground()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib1 = UINib(nibName: "CallToActionCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "CallToActionCell")
        
        let nib2 = UINib(nibName: "QuestionAnswerTableViewCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "QuestionAnswerTableViewCell")
        
        // add a Ask a question button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask a question", style: .Plain, target: self, action: "askQuestionTapped")
        
        self.loadQuestions()
        
    }
    
    func loadQuestions() {
        
        let request = BVQuestionsAndAnswersRequest(productId: product.productId, limit: 20, offset: 0)
        
        self.tableView.load(request, success: { (response) in
            
            self.spinner.removeFromSuperview()
            self.questions = response.results
            self.tableView.reloadData()
            
        })
        { (errors) in
            
            print("An error occurred: \(errors)")
            
        }
        
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
    
    // MARK: UITableViewDatasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     
        return questions.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
   
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
