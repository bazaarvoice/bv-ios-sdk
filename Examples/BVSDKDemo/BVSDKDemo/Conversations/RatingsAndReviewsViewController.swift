//
//  RatingsAndReviewsViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import FontAwesomeKit
import XLActionController

enum ReviewTableSections {
    
    case features
    case summary
    case pros
    case cons
    case positiveQuotes
    case negativeQuotes
    case featureQuotes
    case quotes
    case actionButtons
    case reviews
    
    var title: String {
        switch self {
            
        case .features:
            return "Product Features"
        case .summary:
            return "✨ AI Generated Review Summary"
        case .pros:
            return "Pros"
        case .cons:
            return "Cons"
        case .positiveQuotes:
            return "Most Helpful Review Quotes"
        case .negativeQuotes:
            return "Most Critical Review Quotes"
        case .featureQuotes:
            return "Quotes for Feature"
        case .quotes:
            return "Most Useful Quotes"
        case .actionButtons:
            return "Actions"
        case .reviews:
            return "Reviews"
        }
    }
}

class RatingsAndReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: BVReviewsTableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
    
    private var reviews : [BVReview] = []
    // For demo purposes we save the vote in each cell to rember as the table view cells recycle
    // In production app, you'd want to save the votes for content id and user in a local db.
    private var votesDictionary  = [:] as! Dictionary<String, Votes>
    let product : BVProduct
    var reviewHighlightsProductId: String?
    
    private let numReviewToFetch : Int32 = 20
    private var reviewFetchPending : Bool = false // Is an API call in progress
    var totalReviewCount = 0
        
    enum RatingsAndReviewsSections : Int {
        case filter = 0
        case reviews
        
        static func count() -> Int {
            return 2
        }
    }
    
    enum FilterOptions : Int {
        
        case mostRecent = 0
        case highestRating
        case lowestRating
        case mostHelpful
        case mostComments
        case location           // This is a filter, not a sort
        
    }
    
    private let filterActionTitles = ["Most Recent", "Highest Rating", "Lowest Rating", "Most Helpful", "Most Comments", "Location Filter"]
    
    private var selectedFilterOption : Int = FilterOptions.mostRecent.rawValue
    private var displayReviewHighlights: Bool = false
    private var productSentimentsViewModel: ProductSentimentsViewModelDelegate?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product:BVProduct, totalReviewCount: Int, reviewHighlightsProductId: String?) {
        
        self.totalReviewCount = totalReviewCount
        self.reviewHighlightsProductId = reviewHighlightsProductId
        self.product = product
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileUtils.trackViewController(self)
        
        header.product = product
        
        //Register ReviewHighlights Cell
        self.registerCell()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        
        // add a Write Review button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Write a review", style: .plain, target: self, action: #selector(RatingsAndReviewsViewController.writeReviewTapped))
        
        self.title = "Reviews"
        
        self.loadReviews()
        self.productSentimentsViewModel = ProductSentimentsViewModel(productId: product.identifier)
        self.productSentimentsViewModel?.productSentimentsUIDelegate = self
    }
    
    private func registerCell() {
        let nibConversationsCell = UINib(nibName: "ReviewsSectionsToogleTableViewCell", bundle: nil)
        tableView.register(nibConversationsCell, forCellReuseIdentifier: "ReviewsSectionsToogleTableViewCell")
        
        let nib = UINib(nibName: "ReviewHightlightsTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ReviewHightlightsTableViewCell")
        
        let nib1 = UINib(nibName: "ReviewHighlightsHeaderTableViewCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "ReviewHighlightsHeaderTableViewCell")
        
        let nib2 = UINib(nibName: "RatingTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "RatingTableViewCell")
    }
    
    @objc func writeReviewTapped() {
        
        let vc = WriteReviewViewController(nibName:"WriteReviewViewController", bundle: nil, product: product)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loadReviews() {
        
        reviewFetchPending = true
        
        let request = BVReviewsRequest(productId: product.identifier, limit: 20, offset: UInt(self.reviews.count))
        request.include(.reviewComments)
        // Check sorting and filter FilterOptions
        if selectedFilterOption == FilterOptions.highestRating.rawValue {
            request.sort(by: .reviewRating, monotonicSortOrderValue: .descending)
        } else if selectedFilterOption == FilterOptions.lowestRating.rawValue {
            request.sort(by: .reviewRating, monotonicSortOrderValue: .ascending)
        } else if selectedFilterOption == FilterOptions.mostHelpful.rawValue {
            request.sort(by: .reviewHelpfulness, monotonicSortOrderValue: .descending)
        } else if selectedFilterOption == FilterOptions.mostComments.rawValue {
            request.sort(by: .reviewTotalCommentCount, monotonicSortOrderValue: .descending)
        }
        
        self.tableView.load(request, success: { (response) in
            
            self.spinner.removeFromSuperview()
            
            if (self.reviews.count == 0){
                self.reviews = response.results
            } else {
                self.reviews.append(contentsOf: response.results)
            }
            
            
            self.reviewFetchPending = false
            self.tableView.reloadData()
            
        })
        { (errors) in
            
            print("An error occurred: \(errors)")
            self.reviewFetchPending = false
            
        }
        
    }
    
    private func loadAuthorViewController(authorId: String) {
        
        let authorVC = AuthorProfileViewController(authorId: authorId)
        self.navigationController?.pushViewController(authorVC, animated: true)
        
    }
    
    private func loadCommentsViewController(reviewComments: [BVComment]) {
        
        let reviewCommentsVC = ReviewCommentsViewController(reviewComments: reviewComments)
        self.navigationController?.pushViewController(reviewCommentsVC, animated: true)
        
    }
    
    // MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.reviewTableSections[section] {
        case .actionButtons:
            return 1
        case .reviews:
            return reviews.count
        default:
            return self.productSentimentsViewModel?.getRowCount(self.reviewTableSections[section]) ?? 0
        }
        
       
//            
//            var count = 0
//            
//            switch section {
//            case RatingsAndReviewsSections.reviews.rawValue:
//                count = reviews.count
//                break
//            case RatingsAndReviewsSections.filter.rawValue:
//                count = 1
//                break
//            default:
//                break
//            }
//            
//            return count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.reviewTableSections.count
        //return RatingsAndReviewsSections.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = self.reviewTableSections[indexPath.section]
        switch sectionType {
            
        case .features, .summary, .pros, .cons, .positiveQuotes, .negativeQuotes, .featureQuotes, .quotes:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewHightlightsTableViewCell", for: indexPath) as! ReviewHightlightsTableViewCell
            cell.selectionStyle = .none
//            if let title = self.bVReviewHighlights.negatives?[indexPath.row - 1].title?.capitalized {
//                if let count = self.bVReviewHighlights.negatives?[indexPath.row - 1].bestExamples?.count {
//                    cell.lbl_Title.text = title + " (\(count))"
//                }
//            }
            
            let displayText = self.productSentimentsViewModel?.getText(sectionType, indexPath.row)
            cell.lbl_Title.text = displayText
            if sectionType == .pros {
                cell.lbl_Title.textColor = UIColor.systemGreen
                cell.setBgViewBorder(color: UIColor.systemGreen.withAlphaComponent(0.5))
            } else if sectionType == .cons {
                cell.lbl_Title.textColor = UIColor.systemRed
                cell.setBgViewBorder(color: UIColor.systemRed.withAlphaComponent(0.5))
            } else {
                cell.lbl_Title.textColor = UIColor.systemGray
                cell.setBgViewBorder(color: UIColor.systemGray.withAlphaComponent(0.5))
            }
            return cell

        case .actionButtons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsSectionsToogleTableViewCell") as! ReviewsSectionsToogleTableViewCell

            cell.toggleReviewHighlightsButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.toggleReviewHighlightsButton.addTarget(self, action: #selector(RatingsAndReviewsViewController.toggleReviewHighlightsPressed), for: .touchUpInside)
            cell.setReviewHighlightsButtonTitle(isOn: self.displayReviewHighlights)

            cell.button.removeTarget(nil, action: nil, for: .allEvents)
            cell.button.addTarget(self, action: #selector(RatingsAndReviewsViewController.filterReviewsButtonPressed), for: .touchUpInside)
            cell.setCustomLeftIcon(FAKFontAwesome.sortIcon(withSize:))
            
            let titlePrefix = selectedFilterOption == FilterOptions.location.rawValue ? "Filter:" : "Sort:"
            cell.button.setTitle("\(titlePrefix) \(filterActionTitles[selectedFilterOption])", for: UIControl.State())
            
            return cell
        case .reviews:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
            let review : BVReview  = reviews[(indexPath as NSIndexPath).row]
            cell.review = review
            
            // Check to see if there was a vote on this review id
            var cellVote = Votes.NoVote
            if let previosVote = self.votesDictionary[review.identifier!]{
                cellVote = previosVote
            }
            
            cell.vote = cellVote
            
            
            cell.onAuthorNickNameTapped = { (authorId) -> Void in
                self.loadAuthorViewController(authorId: authorId)
            }
            
            cell.onCommentIconTapped = { (reviewComments) -> Void in
                self.loadCommentsViewController(reviewComments: reviewComments)
            }
            
            cell.onVoteIconTapped = { (idVoteDict) -> Void in
                if let key = idVoteDict.allKeys.first {
                    //self.votesDictionary[key] = idVoteDict.value(forKey: key as! String)
                    let value : Votes = idVoteDict[key as! String] as! Votes
                    self.votesDictionary[key as! String] = value
                }
                
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.reviewTableSections[section] == .actionButtons {
            return CGFloat.leastNormalMagnitude
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 { return }
        
        let lastElement = reviews.count - 5
        if lastElement > 0 && (indexPath as NSIndexPath).row == lastElement {
            
            if totalReviewCount > reviews.count && !reviewFetchPending {
                self.loadReviews()
                print("should load more with current review count at = \(self.reviews.count)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.reviewTableSections[section] == .actionButtons {
            return nil
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewHighlightsHeaderTableViewCell") as! ReviewHighlightsHeaderTableViewCell
        cell.selectionStyle = .none
        cell.lbl_Title.text = self.reviewTableSections[section].title
        
        return cell
    }
    
    @objc func toggleReviewHighlightsPressed() {
        self.displayReviewHighlights = !self.displayReviewHighlights
        self.tableView.reloadData()
    }
    
    @objc func filterReviewsButtonPressed() {
        
        let actionController = BVSDKDemoActionController()
        
        actionController.addAction(Action(filterActionTitles[FilterOptions.mostRecent.rawValue], style: .default, handler: { action in
            self.didChangeFilterOption(FilterOptions.mostRecent)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.highestRating.rawValue], style: .default, handler: { action in
            self.didChangeFilterOption(FilterOptions.highestRating)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.lowestRating.rawValue], style: .default, handler: { action in
            self.didChangeFilterOption(FilterOptions.lowestRating)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.mostHelpful.rawValue], style: .default, handler: { action in
            self.didChangeFilterOption(FilterOptions.mostHelpful)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.mostComments.rawValue], style: .default, handler: { action in
            self.didChangeFilterOption(FilterOptions.mostComments)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.location.rawValue], style: .default, handler: { action in
            self.didChangeFilterOption(FilterOptions.location)
        }))
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
        
        present(actionController, animated: true, completion: nil)
        
    }
    
    func didChangeFilterOption(_ option : FilterOptions){
        
        if selectedFilterOption == option.rawValue {
            return // ignore, didn't change anything
        }
        
        self.tableView.reloadSections(IndexSet(integer: RatingsAndReviewsSections.filter.rawValue), with: .none)
        selectedFilterOption = option.rawValue
        print("Selected filter option: \(filterActionTitles[selectedFilterOption])")
        
        reviews = []
        self.loadReviews()
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.reviewTableSections[indexPath.section]
        if type == .features || type == .pros || type == .cons {
            self.productSentimentsViewModel?.didSelectFeatureAtIndex(type, indexPath.row)
        }
    }
}

extension RatingsAndReviewsViewController {
    var reviewTableSections: [ReviewTableSections] {
        if displayReviewHighlights {
            return [
                .summary,
                .features,
                .quotes,
                .pros,
                .cons,
//                .positiveQuotes,
//                .negativeQuotes,
                .featureQuotes,
                .actionButtons,
                .reviews
            ]
        } else {
            return [
                .summary,
                .actionButtons,
                .reviews
            ]
        }
    }
}

extension RatingsAndReviewsViewController: ProductSentimentsUIDelegate {
    func reloadData() {
        self.tableView.reloadData()
    }
}
