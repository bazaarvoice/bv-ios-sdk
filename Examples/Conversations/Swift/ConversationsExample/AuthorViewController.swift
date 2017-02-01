//
//  AuthorViewController.swift
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class AuthorViewController: UIViewController {

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
        authorProfileTableView.registerNib(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
        authorProfileTableView.registerNib(UINib(nibName: "MyReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableViewCell")
        authorProfileTableView.registerNib(UINib(nibName: "MyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyQuestionTableViewCell")
        authorProfileTableView.registerNib(UINib(nibName: "MyAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswerTableViewCell")

        let authorId = "data-gen-user-c3k8hjvtpn03dupvxcui1rj3"
        
        let request = BVAuthorRequest(authorId: authorId)
        // stats includes
        request.includeStatistics(.Answers)
        request.includeStatistics(.Questions)
        .includeStatistics(.Reviews)
        // other includes
        request.includeContent(.Reviews, limit: 10)
        request.includeContent(.Questions, limit: 10)
        request.includeContent(.Answers, limit: 10)
        // sorts
        request.sortIncludedAnswers(.SubmissionTime, order: .Descending)
        request.sortIncludedReviews(.SubmissionTime, order: .Descending)
        request.sortIncludedQuestions(.SubmissionTime, order: .Descending)
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AuthorSections.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.authorResponse == nil {
            return 0;
        }
        
        let author = self.authorResponse?.results.first!
        
        switch section {
        case AuthorSections.ProfileStats.rawValue:
            return 1;
        case AuthorSections.IncludedReviews.rawValue:
            return (author?.includedReviews.count)!;
        case AuthorSections.IncludedQuestions.rawValue:
            return (author?.includedQuestions.count)!;
        case AuthorSections.IncludedAnswers.rawValue:
            return (author?.includedAnswers.count)!;
        default:
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let author = self.authorResponse?.results.first!
        
        switch indexPath.section {
        case AuthorSections.ProfileStats.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("StatisticTableViewCell")! as! StatisticTableViewCell
            cell.statTypeLabel.text = "Author Statistics";
            cell.statValueLabel.text = self.createAutorStats(author!)
            return cell
        case AuthorSections.IncludedReviews.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("MyReviewTableViewCell")! as! MyReviewTableViewCell
            cell.review = author!.includedReviews[indexPath.row]
            return cell
        case AuthorSections.IncludedQuestions.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("MyQuestionTableViewCell")! as! MyQuestionTableViewCell
            cell.question = author!.includedQuestions[indexPath.row]
            cell.accessoryType = .None
            return cell
        case AuthorSections.IncludedAnswers.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("MyAnswerTableViewCell")! as! MyAnswerTableViewCell
            cell.answer = author!.includedAnswers[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }

    
    
}
