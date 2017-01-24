//
//  PDPViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class PDPViewController: BVProductDisplayPageViewController, UITableViewDataSource {
    
    @IBOutlet weak var demoStatsTableView: UITableView!
    
    enum StatSections : Int {
        case ReviewStats
        case QAStats
        
        static var count: Int { return StatSections.QAStats.hashValue + 1}
    }
    
    enum ReviewStateRows : Int {
        case TotalReviewCount
        case AverageOverallRating
        case HelpfulVoteCount
        case NotHelpfulVoteCount
        case RecommendedCount
        case NotRecommendedCount
        case OverallRatingRange
        
        static var count: Int { return ReviewStateRows.OverallRatingRange.hashValue + 1}
    }
    
    enum QAStatRows : Int {
        case TotalQuestions
        case TotalAnswers
        case AnswerHelpfulVoteCount
        case AnswerNotHelpfulVoteCount
        case QuestionHelpfulVoteCount
        case QuestionNotHelpfulVoteCount
        
        static var count: Int { return QAStatRows.QuestionNotHelpfulVoteCount.hashValue + 1}
    }
    
    var reviewStats = BVReviewStatistics()
    var questionAnswerStats = BVQAStatistics()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demoStatsTableView.estimatedRowHeight = 80
        demoStatsTableView.rowHeight = UITableViewAutomaticDimension
        demoStatsTableView.registerNib(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
        
        let productPage = BVProductDisplayPageRequest(productId: "test1")
        .includeStatistics(.Reviews)
        .includeStatistics(.Questions)
        .includeStatistics(.Answers)
        
        productPage.load({ (response) in
            
            self.reviewStats         = (response.result?.reviewStatistics)!
            self.questionAnswerStats = (response.result?.qaStatistics)!
            
            self.demoStatsTableView.reloadData()
            
            }) { (error) in
                print(error)
        }
        
    }
    
    // MARK: UITableViewDatasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return StatSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            case StatSections.ReviewStats.rawValue:
                return "Product Review Statistics"
            case StatSections.QAStats.rawValue:
                return "Product Question & Answer Statistics"
            default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case StatSections.ReviewStats.rawValue:
            return ReviewStateRows.count
        case StatSections.QAStats.rawValue:
            return QAStatRows.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StatisticTableViewCell")! as! StatisticTableViewCell
        
        switch indexPath.section {
            
            case StatSections.ReviewStats.rawValue:
                        
            switch indexPath.row {
                case ReviewStateRows.TotalReviewCount.rawValue:
                    cell.statTypeLabel.text = "Total Review Count"
                    cell.statValueLabel.text = reviewStats.totalReviewCount?.stringValue
                case ReviewStateRows.AverageOverallRating.rawValue:
                    cell.statTypeLabel.text = "Average Overall Rating"
                    cell.statValueLabel.text = reviewStats.averageOverallRating?.stringValue
                case ReviewStateRows.HelpfulVoteCount.rawValue:
                    cell.statTypeLabel.text = "Helpful Vote Count"
                    cell.statValueLabel.text = reviewStats.helpfulVoteCount?.stringValue
                case ReviewStateRows.NotHelpfulVoteCount.rawValue:
                    cell.statTypeLabel.text = "Not Helpful Vote Count"
                    cell.statValueLabel.text = reviewStats.notHelpfulVoteCount?.stringValue
                case ReviewStateRows.RecommendedCount.rawValue:
                    cell.statTypeLabel.text = "Recommended Count"
                    cell.statValueLabel.text = reviewStats.recommendedCount?.stringValue
                case ReviewStateRows.NotRecommendedCount.rawValue:
                    cell.statTypeLabel.text = "Not Recommeded Count"
                    cell.statValueLabel.text = reviewStats.notRecommendedCount?.stringValue
                case ReviewStateRows.OverallRatingRange.rawValue:
                    cell.statTypeLabel.text = "Overall Rating Range"
                    cell.statValueLabel.text = reviewStats.overallRatingRange?.stringValue
                default:
                    cell.statTypeLabel.text = "Error"
                    cell.statValueLabel.text = "Error"

            }
            
        case StatSections.QAStats.rawValue:
            
            switch indexPath.row {
                case QAStatRows.TotalQuestions.rawValue:
                    cell.statTypeLabel.text = "Total Question Count"
                    cell.statValueLabel.text = questionAnswerStats.totalQuestionCount?.stringValue
                case QAStatRows.TotalAnswers.rawValue:
                    cell.statTypeLabel.text = "Total Answer Count"
                    cell.statValueLabel.text = questionAnswerStats.totalAnswerCount?.stringValue
                case QAStatRows.AnswerHelpfulVoteCount.rawValue:
                    cell.statTypeLabel.text = "Answer Helpful Vote Count"
                    cell.statValueLabel.text = questionAnswerStats.answerHelpfulVoteCount?.stringValue
                case QAStatRows.AnswerNotHelpfulVoteCount.rawValue:
                    cell.statTypeLabel.text = "Answer Not Helpful Vote Count"
                    cell.statValueLabel.text = questionAnswerStats.answerNotHelpfulVoteCount?.stringValue
                case QAStatRows.QuestionHelpfulVoteCount.rawValue:
                    cell.statTypeLabel.text = "Question Helpful Vote Count"
                    cell.statValueLabel.text = questionAnswerStats.questionHelpfulVoteCount?.stringValue
                case QAStatRows.QuestionNotHelpfulVoteCount.rawValue:
                    cell.statTypeLabel.text = "Question Not Helpful Vote Count"
                    cell.statValueLabel.text = questionAnswerStats.questionNotHelpfulVoteCount?.stringValue
                default:
                    cell.statTypeLabel.text = "Error"
                    cell.statValueLabel.text = "Error"
            }
            
        default:
            print("Bad section provided for stats table view")
        }
        
        return cell
    }
    
}
