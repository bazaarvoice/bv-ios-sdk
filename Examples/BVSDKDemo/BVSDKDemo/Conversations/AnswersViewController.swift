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
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
    
    let product : BVProduct
    let question : BVQuestion
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product: BVProduct, question: BVQuestion) {
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
        tableView.register(nib1, forCellReuseIdentifier: "AnswerListHeaderCell")
        
        let nib2 = UINib(nibName: "ProductPageButtonCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ProductPageButtonCell")
        
        let nib3 = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "AnswerTableViewCell")
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        else {
            return question.answers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerListHeaderCell") as! AnswerListHeaderCell
                
                
                cell.question = question
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPageButtonCell") as! ProductPageButtonCell
                
                cell.button.setTitle("Give your answer!", for: UIControlState())
                cell.setCustomLeftIcon(FAKFontAwesome.plusIcon(withSize:))
                cell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
                cell.button.removeTarget(nil, action: nil, for: .allEvents)
                cell.button.addTarget(self, action: #selector(AnswersViewController.writeAnAnswerTapped), for: .touchUpInside)
                
                return cell
            }
            
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell") as! AnswerTableViewCell
            
            cell.answer = question.answers[indexPath.row]
            
            return cell
        }
        
    }
    
    func writeAnAnswerTapped() {
        
        let vc = SubmitAnswerViewController(nibName: "SubmitAnswerViewController", bundle: nil, product:product,  question: question)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
