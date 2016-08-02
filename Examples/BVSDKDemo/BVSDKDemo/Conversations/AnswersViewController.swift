//
//  AnswersViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import FontAwesomeKit

class AnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: BVAnswersTableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSizeMake(44,44), padding: 0)
    
    let product : BVRecommendedProduct
    let question : BVQuestion
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product: BVRecommendedProduct, question: BVQuestion) {
        self.question = question
        self.product = product
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Answers"
        
        ProfileUtils.trackViewController(self)

        header.product = product
        
        self.view.backgroundColor = UIColor.appBackground()
        self.tableView.backgroundColor = UIColor.appBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib1 = UINib(nibName: "AnswerListHeaderCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "AnswerListHeaderCell")
        
        let nib2 = UINib(nibName: "ProductPageButtonCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "ProductPageButtonCell")

        let nib3 = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        tableView.registerNib(nib3, forCellReuseIdentifier: "AnswerTableViewCell")
        
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     
        return 2
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0 {
            return 2
        }
        else {
            return question.answers.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("AnswerListHeaderCell") as! AnswerListHeaderCell
                
                
                cell.question = question
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ProductPageButtonCell") as! ProductPageButtonCell
                
                cell.button.setTitle("Give your answer!", forState: .Normal)
                cell.setCustomLeftIcon(FAKFontAwesome.plusIconWithSize)
                cell.setCustomRightIcon(FAKFontAwesome.chevronRightIconWithSize)
                cell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                cell.button.addTarget(self, action: "writeAnAnswerTapped", forControlEvents: .TouchUpInside)
                
                return cell
            }
            
        }
        
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AnswerTableViewCell") as! AnswerTableViewCell
            
            cell.answer = question.answers[indexPath.row]
            
            return cell
        }
        
    }
    
    func writeAnAnswerTapped() {
        
        let vc = SubmitAnswerViewController(nibName: "SubmitAnswerViewController", bundle: nil, product:product,  question: question)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
