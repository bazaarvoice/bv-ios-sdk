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

class StoreReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: BVStoreReviewsTableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSizeMake(44,44), padding: 0)
    
    private var reviews : [BVReview] = []
    let store : BVStore
    
    private let numReviewToFetch : Int32 = 20
    private var reviewFetchPending : Bool = false // Is an API call in progress
    var totalReviewCount = 0
    
    enum RatingsAndReviewsSections : Int {
        case Filter = 0
        case Reviews
        
        static func count() -> Int {
            return 2
        }
    }
    
    enum FilterOptions : Int {
        
        case MostRecent = 0
        case HighestRating
        case LowestRating
        case MostHelpful
    }
    
    private let filterActionTitles = ["Most Recent", "Highest Rating", "Lowest Rating", "Most Helpful"]
    
    private var selectedFilterOption : Int = FilterOptions.MostRecent.rawValue
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, store:BVStore, totalReviewCount: Int) {
        
        self.totalReviewCount = totalReviewCount
        self.store = store
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileUtils.trackViewController(self)
        
        header.store = store
        
        let nib = UINib(nibName: "RatingTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "RatingTableViewCell")
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Write a review", style: .Plain, target: self, action: "writeReviewTapped")
        
        self.title = "Store Reviews"
        
        let nibConversationsCell = UINib(nibName: "ProductPageButtonCell", bundle: nil)
        tableView.registerNib(nibConversationsCell, forCellReuseIdentifier: "ProductPageButtonCell")
        
        self.loadStoreReviews()
        
    }
    
    func writeReviewTapped() {
        
        let storeReviewsVC = StoreWriteReviewViewController(nibName:"StoreWriteReviewViewController", bundle: nil)
        storeReviewsVC.store = store
        self.navigationController?.pushViewController(storeReviewsVC, animated: true)
        
    }
    
    
    func loadStoreReviews() {

        reviewFetchPending = true
        
        let request = BVStoreReviewsRequest(storeId: store.identifier!, limit: 20, offset: Int32(self.reviews.count))

        // Check sorting and filter FilterOptions
        if selectedFilterOption == FilterOptions.HighestRating.rawValue {
            request.addSort(.Rating, order: .Descending)
        } else if selectedFilterOption == FilterOptions.LowestRating.rawValue {
            request.addSort(.Rating, order: .Ascending)
        } else if selectedFilterOption == FilterOptions.MostHelpful.rawValue {
            request.addSort(.Helpfulness, order: .Descending)
        }
        
        self.tableView.load(request, success: { (response) in

            self.spinner.removeFromSuperview()
            
            if (self.reviews.count == 0){
                self.reviews = response.results
            } else {
                self.reviews.appendContentsOf(response.results)
            }
            
            self.reviewFetchPending = false
            self.tableView.reloadData()

            })
        { (errors) in

            print("An error occurred: \(errors)")
            self.reviewFetchPending = false
            
        }
        
    }
    
    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch section {
        case RatingsAndReviewsSections.Reviews.rawValue:
            count = reviews.count
            break
        case RatingsAndReviewsSections.Filter.rawValue:
            count = 1
            break
        default:
            break
        }
        
        return count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return RatingsAndReviewsSections.count()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == RatingsAndReviewsSections.Reviews.rawValue {
            return 22
        }
        
        
        return 0
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case RatingsAndReviewsSections.Filter.rawValue:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductPageButtonCell") as! ProductPageButtonCell
            
            cell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell.button.addTarget(self, action: "filterReviewsButtonPressed", forControlEvents: .TouchUpInside)
            cell.setCustomLeftIcon(FAKFontAwesome.sortIconWithSize)
            cell.setCustomRightIcon(FAKFontAwesome.chevronRightIconWithSize)
            
            
            let titlePrefix = "Sort:"
            cell.button.setTitle("\(titlePrefix) \(filterActionTitles[selectedFilterOption])", forState: .Normal)
            
            return cell
            
        case RatingsAndReviewsSections.Reviews.rawValue:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("RatingTableViewCell") as! RatingTableViewCell
            cell.review = reviews[indexPath.row]
            return cell
            
        default:
            break
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 { return }
        
        let lastElement = reviews.count - 5
        if lastElement > 0 && indexPath.row == lastElement {
            
            if totalReviewCount > reviews.count && !reviewFetchPending {
                self.loadStoreReviews()
                print("should load more with current review count at = \(self.reviews.count)")
            }
        }
    }
    
    func filterReviewsButtonPressed() {
        
        let actionController = BVSDKDemoActionController()
        
        actionController.addAction(Action(filterActionTitles[FilterOptions.MostRecent.rawValue], style: .Default, handler: { action in
            self.didChangeFilterOption(FilterOptions.MostRecent)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.HighestRating.rawValue], style: .Default, handler: { action in
            self.didChangeFilterOption(FilterOptions.HighestRating)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.LowestRating.rawValue], style: .Default, handler: { action in
            self.didChangeFilterOption(FilterOptions.LowestRating)
        }))
        actionController.addAction(Action(filterActionTitles[FilterOptions.MostHelpful.rawValue], style: .Default, handler: { action in
            self.didChangeFilterOption(FilterOptions.MostHelpful)
        }))
        actionController.addAction(Action("Cancel", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    func didChangeFilterOption(option : FilterOptions){
        
        if selectedFilterOption == option.rawValue {
            return // ignore, didn't change anything
        }
        
        self.tableView.reloadSections(NSIndexSet(index: RatingsAndReviewsSections.Filter.rawValue), withRowAnimation: .None)
        selectedFilterOption = option.rawValue
        print("Selected filter option: \(filterActionTitles[selectedFilterOption])")
        
        reviews = []
        self.loadStoreReviews()
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Currently nothing to do when selecting a review
        // But we could add further review author details (e.g. profile view)
        
        return;
        
    }
    
}

