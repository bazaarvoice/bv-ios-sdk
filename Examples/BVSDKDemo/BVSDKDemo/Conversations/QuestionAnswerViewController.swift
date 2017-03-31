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

    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
    let product: BVProduct
    var questions : [BVQuestion] = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product:BVProduct?) {
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
        tableView.register(nib1, forCellReuseIdentifier: "CallToActionCell")
        
        let nib2 = UINib(nibName: "QuestionAnswerTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "QuestionAnswerTableViewCell")
        
        // add a Ask a question button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask a question", style: .plain, target: self, action: #selector(QuestionAnswerViewController.askQuestionTapped))
        
        self.loadQuestions()
        
    }
    
    func loadQuestions() {
        
        let request = BVQuestionsAndAnswersRequest(productId: product.identifier, limit: 20, offset: 0)
        
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
    
    func submitAnswerPressed(_ sender: UIButton) {
        
        let indexPathSection = sender.tag
        let question = questions[indexPathSection]
        
        let vc = SubmitAnswerViewController(nibName: "SubmitAnswerViewController", bundle: nil, product: product, question: question)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func readAnswersTapped(_ sender: UIButton) {
        
        let indexPathSection = sender.tag
        let question = questions[indexPathSection]
        
        let vc = AnswersViewController(nibName: "AnswersViewController", bundle: nil, product: product, question: question)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: UITableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
     
        return questions.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let question = questions[(indexPath as NSIndexPath).section]
        
        if (indexPath as NSIndexPath).row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerTableViewCell") as! QuestionAnswerTableViewCell
            cell.question = question
            cell.onAuthorNickNameTapped = { (authorId) -> Void in
                let authorVC = AuthorProfileViewController(nibName: "AuthorProfileViewController", bundle: nil, authorId: authorId)
                self.navigationController?.pushViewController(authorVC, animated: true)
            }
            return cell
            
        }
        else {
            
            let callToActionCell = tableView.dequeueReusableCell(withIdentifier: "CallToActionCell") as! CallToActionCell
            callToActionCell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
            
            let numAnswers = question.answers.count
            if numAnswers == 0 {
                callToActionCell.button.setTitle("Be the first to answer!", for: UIControlState())
                callToActionCell.setCustomLeftIcon(FAKFontAwesome.plusIcon(withSize:))
                callToActionCell.button.removeTarget(nil, action: nil, for: .allEvents)
                callToActionCell.button.tag = (indexPath as NSIndexPath).section
                callToActionCell.button.addTarget(self, action: #selector(QuestionAnswerViewController.submitAnswerPressed(_:)), for: .touchUpInside)
            }
            else {
                callToActionCell.button.setTitle("Read \(numAnswers) answers", for: UIControlState())
                callToActionCell.setCustomLeftIcon(FAKFontAwesome.commentsIcon(withSize:))
                callToActionCell.button.removeTarget(nil, action: nil, for: .allEvents)
                callToActionCell.button.tag = (indexPath as NSIndexPath).section
                callToActionCell.button.addTarget(self, action: #selector(QuestionAnswerViewController.readAnswersTapped(_:)), for: .touchUpInside)
            }
            
            return callToActionCell
            
        }
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
