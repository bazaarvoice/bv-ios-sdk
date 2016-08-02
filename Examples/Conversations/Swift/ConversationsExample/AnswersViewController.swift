//
//  AnswersViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class AnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var answersTableView: BVAnswersTableView!
    var question : BVQuestion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.estimatedRowHeight = 68
        answersTableView.rowHeight = UITableViewAutomaticDimension
        answersTableView.registerNib(UINib(nibName: "MyAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswerTableViewCell")
        
    }
    
    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Answer Responses"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question!.answers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyAnswerTableViewCell")! as! MyAnswerTableViewCell
        
        cell.answer = question!.answers[indexPath.row];
        
        return cell
    }
    
}

