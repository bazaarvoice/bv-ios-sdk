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
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
    
    private var reviews : [BVReview] = []
    private let store : BVStore
    
    private let numReviewToFetch : Int32 = 20
    private var reviewFetchPending : Bool = false // Is an API call in progress
    private var totalReviewCount = 0
    
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
    }
    
    private let filterActionTitles = ["Most Recent", "Highest Rating", "Lowest Rating", "Most Helpful"]
    
    private var selectedFilterOption : Int = FilterOptions.mostRecent.rawValue
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, store:BVStore, totalReviewCount: Int) {
        
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
        tableView.register(nib, forCellReuseIdentifier: "RatingTableViewCell")
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Write a review", style: .plain, target: self, action: #selector(StoreReviewsViewController.writeReviewTapped))
        
        self.title = "Store Reviews"
        
        let nibConversationsCell = UINib(nibName: "ProductPageButtonCell", bundle: nil)
        tableView.register(nibConversationsCell, forCellReuseIdentifier: "ProductPageButtonCell")
        
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
        if selectedFilterOption == FilterOptions.highestRating.rawValue {
            request.addSort(.rating, order: .descending)
        } else if selectedFilterOption == FilterOptions.lowestRating.rawValue {
            request.addSort(.rating, order: .ascending)
        } else if selectedFilterOption == FilterOptions.mostHelpful.rawValue {
            request.addSort(.helpfulness, order: .descending)
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
    
    // MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch section {
        case RatingsAndReviewsSections.reviews.rawValue:
            count = reviews.count
            break
        case RatingsAndReviewsSections.filter.rawValue:
            count = 1
            break
        default:
            break
        }
        
        return count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RatingsAndReviewsSections.count()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == RatingsAndReviewsSections.reviews.rawValue {
            return 22
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch (indexPath as NSIndexPath).section {
        case RatingsAndReviewsSections.filter.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPageButtonCell") as! ProductPageButtonCell
            
            cell.button.removeTarget(nil, action: nil, for: .allEvents)
            cell.button.addTarget(self, action: #selector(StoreReviewsViewController.filterReviewsButtonPressed), for: .touchUpInside)
            cell.setCustomLeftIcon(FAKFontAwesome.sortIcon(withSize:))
            cell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
            
            
            let titlePrefix = "Sort:"
            cell.button.setTitle("\(titlePrefix) \(filterActionTitles[selectedFilterOption])", for: UIControlState())
            
            return cell
            
        case RatingsAndReviewsSections.reviews.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
            cell.review = reviews[(indexPath as NSIndexPath).row]
            return cell
            
        default:
            break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 { return }
        
        let lastElement = reviews.count - 5
        if lastElement > 0 && (indexPath as NSIndexPath).row == lastElement {
            
            if totalReviewCount > reviews.count && !reviewFetchPending {
                self.loadStoreReviews()
                print("should load more with current review count at = \(self.reviews.count)")
            }
        }
    }
    
    func filterReviewsButtonPressed() {
        
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
        self.loadStoreReviews()
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Currently nothing to do when selecting a review
        // But we could add further review author details (e.g. profile view)
        
        return;
        
    }
    
}

