//
//  SearchViewController.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 04/11/2019.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import FontAwesomeKit

//For manage the availabe options.
struct RadioButton {
    var buttonName: String = ""
    var isSelected: Bool = false
}


//        self.productName.text = product?.name
//        if let url  = product?.imageUrl {
//          self.productImage.sd_setImage(with: URL(string: url))
//        }
struct SearchedProduct {
    var productName: String = ""
    var imageUrl: String = ""
}

class SearchViewController: UIViewController {
    
    var radioButtonArray: [RadioButton] = []
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_TableBackground: UIView!
    @IBOutlet weak var view_Upper: UIView!
    @IBOutlet weak var tableView: BVQuestionsTableView!
    @IBOutlet weak var tableViewForRatings: BVReviewsTableView!
    @IBOutlet weak var tableViewforProduct: UITableView!
    @IBOutlet weak var tableViewForComments: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var questions: [BVQuestion] = []
    var reviews: [BVReview] = []
    var author: BVAuthor?
    var searchedProductArray: [SearchedProduct] = []
    
    private var votesDictionary  = [:] as! Dictionary<String, Votes>
    
    //For demo product is default selected option
    private var selectedOption: String = "product"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.cellRegistration()
        self.setRadioButton()
    }
    
    //Create Array for search Options.
    private func setRadioButton() {
        self.radioButtonArray = []
        
        self.radioButtonArray.append(RadioButton(buttonName: "Products", isSelected: true))
        self.radioButtonArray.append(RadioButton(buttonName: "Comments", isSelected: false))
        self.radioButtonArray.append(RadioButton(buttonName: "Reviews", isSelected: false))
        self.radioButtonArray.append(RadioButton(buttonName: "Questions", isSelected: false))
    }
    
    //Registration of TableView and CollectionView Cell
    private func cellRegistration() {
        
        let nib11 = UINib(nibName: "SearchContentCollectionViewCell", bundle: nil)
        self.collectionView.register(nib11, forCellWithReuseIdentifier: "SearchContentCollectionViewCell")
        
        let nib2 = UINib(nibName: "ReviewCommentTableViewCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "ReviewCommentTableViewCell")
        
        let nib3 = UINib(nibName: "QuestionAnswerTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "QuestionAnswerTableViewCell")
        
        let nib4 = UINib(nibName: "CallToActionCell", bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: "CallToActionCell")
        
        let nib5 = UINib(nibName: "RatingTableViewCell", bundle: nil)
        tableViewForRatings.register(nib5, forCellReuseIdentifier: "RatingTableViewCell")
        
        let nib6 = UINib(nibName: "ReviewCommentTableViewCell", bundle: nil)
        tableViewForComments.register(nib6, forCellReuseIdentifier: "ReviewCommentTableViewCell")
        
        let nib7 = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableViewforProduct.register(nib7, forCellReuseIdentifier: "ProductTableViewCell")
    }
}

//Extension for UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return 2
        }
        else if tableView == self.tableViewForRatings {
            return 2
        }
        else if tableView == self.tableViewForComments {
            return self.author == nil ? 0 : (self.author?.includedComments.count)!
        }
        else if tableView == self.tableViewforProduct {
            return self.searchedProductArray.count
        }
        else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return self.questions.count
        }
        else if tableView == self.tableViewForRatings {
            return self.reviews.count
        }
        else if tableView == self.tableViewForComments {
            return 1
        }
        else if tableView == self.tableViewforProduct {
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //QA TableView
        if tableView == self.tableView {
            
            if (indexPath as NSIndexPath).row == 0 {
                
                return self.questionAnswerTableViewCell(indexPath: indexPath)
            }
            else {
                
                return self.callToActionCell(indexPath: indexPath)
                
            }
        }
        else if tableView == self.tableViewForRatings {
            return self.ratingTableViewCell(indexPath: indexPath)
        }
        else if tableView == self.tableViewForComments {
            return self.reviewCommentTableViewCell(indexPath: indexPath)
        }
        else if tableView == self.tableViewforProduct {
            return self.productTableViewCell(indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
}

extension SearchViewController {
    
    private func callToActionCell(indexPath: IndexPath) -> CallToActionCell {
        
        let question = questions[(indexPath as NSIndexPath).section]
        
        let callToActionCell = tableView.dequeueReusableCell(withIdentifier: "CallToActionCell") as! CallToActionCell
        callToActionCell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
        
        let numAnswers = question.includedAnswers.count
        if numAnswers == 0 {
            callToActionCell.button.setTitle("Be the first to answer!", for: UIControl.State())
            callToActionCell.setCustomLeftIcon(FAKFontAwesome.plusIcon(withSize:))
            callToActionCell.button.removeTarget(nil, action: nil, for: .allEvents)
            callToActionCell.button.tag = (indexPath as NSIndexPath).section
            callToActionCell.button.addTarget(self, action: #selector(QuestionAnswerViewController.submitAnswerPressed(_:)), for: .touchUpInside)
        }
        else {
            callToActionCell.button.setTitle("Read \(numAnswers) answers", for: UIControl.State())
            callToActionCell.setCustomLeftIcon(FAKFontAwesome.commentsIcon(withSize:))
            callToActionCell.button.removeTarget(nil, action: nil, for: .allEvents)
            callToActionCell.button.tag = (indexPath as NSIndexPath).section
            callToActionCell.button.addTarget(self, action: #selector(QuestionAnswerViewController.readAnswersTapped(_:)), for: .touchUpInside)
        }
        
        return callToActionCell
    }
    
    private func questionAnswerTableViewCell(indexPath: IndexPath) -> QuestionAnswerTableViewCell {
        
        let question = questions[(indexPath as NSIndexPath).section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerTableViewCell") as! QuestionAnswerTableViewCell
        cell.question = question
        cell.onAuthorNickNameTapped = { (authorId) -> Void in
            let authorVC = AuthorProfileViewController(authorId: authorId)
            self.navigationController?.pushViewController(authorVC, animated: true)
        }
        return cell
    }
    
    private func ratingTableViewCell(indexPath: IndexPath) -> RatingTableViewCell {
        
        let cell = tableViewForRatings.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
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
    
    private func reviewCommentTableViewCell(indexPath: IndexPath) -> ReviewCommentTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCommentTableViewCell") as! ReviewCommentTableViewCell
        cell.comment = self.author?.includedComments[indexPath.row]
        return cell
    }
    
    private func productTableViewCell(indexPath: IndexPath) -> ProductTableViewCell {
        
        let cell = tableViewforProduct.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        cell.product = self.searchedProductArray[indexPath.row]
        return cell
    }
}

//Extension for UICollectionViewDataSource and UICollectionDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.radioButtonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchContentCollectionViewCell", for: indexPath) as! SearchContentCollectionViewCell
        cell.buttonData = self.radioButtonArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Update the selected option
        self.selectedOption = self.radioButtonArray[indexPath.row].buttonName.lowercased()
        
        switch self.radioButtonArray[indexPath.row].buttonName.lowercased() {
            
        case "products":
            //Clear Search API
            self.searchBar.text = ""
            self.view_TableBackground.bringSubviewToFront(self.tableViewforProduct)
            break
            
        case "comments":
            //Clear Search API
            self.searchBar.text = ""
            self.view_TableBackground.bringSubviewToFront(self.tableViewForComments)
            break
            
        case "reviews":
            //Clear Search API
            self.searchBar.text = ""
            self.view_TableBackground.bringSubviewToFront(self.tableViewForRatings)
            break
            
        case "questions":
            //Clear Search API
            self.searchBar.text = ""
            self.view_TableBackground.bringSubviewToFront(self.tableView)
            break
            
        default:
            //Refresh the Data
            self.collectionView.reloadData()
        }
        
        //Removing the selected option
        for i in 0..<self.radioButtonArray.count {
            self.radioButtonArray[i].isSelected = false
        }
        
        //Enable the selected option.
        self.radioButtonArray[indexPath.row].isSelected = true
        
        //Refresh the Data
        self.collectionView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.resignFirstResponder()
        print("Working Fine")
        
        self.view.endEditing(true)
        
        
        switch self.selectedOption.lowercased() {
        case "products":
            self.loadConversationsStats(productId: searchBar.text ?? "")
            break
            
        case "comments":
            self.fetchAuthorProfile(authorId: searchBar.text ?? "")
            break
            
        case "reviews":
            self.loadReviews(productId: searchBar.text ?? "")
            
            break
            
        case "questions":
            
            self.loadQuestions(productId: searchBar.text ?? "")
            
            break
        default:
            return
        }
    }
}

extension SearchViewController {
    
    func loadQuestions(productId: String) {
        
        let request = BVQuestionsAndAnswersRequest(productId: productId, limit: 20, offset: 0)
        
        self.tableView.load(request, success: { (response) in
            
            self.questions = response.results
            self.tableView.reloadData()
            
        })
        { (errors) in
            
            print("An error occurred: \(errors)")
            
        }
    }
    
    func loadReviews(productId: String) {
        
        //reviewFetchPending = true
        
        let request = BVReviewsRequest(productId: productId, limit: 20, offset: 0)// UInt(self.reviews.count))
        request.include(.reviewComments)
        
        self.tableViewForRatings.load(request, success: { (response) in
            
            //self.spinner.removeFromSuperview()
            
            if (self.reviews.count == 0){
                self.reviews = response.results
            } else {
                self.reviews.append(contentsOf: response.results)
            }
            
            
            //  self.reviewFetchPending = false
            self.tableViewForRatings.reloadData()
            
        })
        { (errors) in
            
            print("An error occurred: \(errors)")
            //self.reviewFetchPending = false
            
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
    
    private func fetchAuthorProfile(authorId: String){
        
        //self.reviewsTableView.addSubview(self.spinner)
        
        let request = BVAuthorRequest(authorId: authorId)
        // stats includes
        request.includeStatistics(.authorAnswers)
        request.includeStatistics(.authorQuestions)
        request.includeStatistics(.authorReviews)
        // other includes
        request.include(.authorReviews, limit: 20)
        request.include(.authorQuestions, limit: 20)
        request.include(.authorAnswers, limit: 20)
        request.include(.authorReviewComments, limit: 20)
        // sorts
        request.sort(by: .answerSubmissionTime, monotonicSortOrderValue: .descending)
        request.sort(by: .reviewSubmissionTime, monotonicSortOrderValue: .descending)
        request.sort(by: .questionSubmissionTime, monotonicSortOrderValue: .descending)
        
        request.load({ (response) in
            
            // success
            if response.results.isEmpty {
                _ = SweetAlert().showAlert("Empty Profile", subTitle:"There was no profile found.", style: .error)
                return
            }
            
            self.author = response.results.first!
            
            //  self.userNameLabel.text = self.author?.userNickname
            
            let location = self.author?.userLocation != nil ? (self.author?.userLocation)! : ""
            // self.userLocationLabel.text = location
            
            // Just adding badge text here, really we want to use an image
            var badgeString = ""
            for badge in (self.author?.badges)! {
                badgeString += badge.identifier!.uppercased()
                if !(badge.isEqual(self.author?.badges.last)) {
                    badgeString += ", "
                } else {
                    badgeString = " " + badgeString + " "
                }
            }
            //self.userBadgesLabel.text = badgeString
            
            let totalCommentCount = self.author!.includedComments.count
            
            let commentButtonText = "Comments (\(totalCommentCount))"
            
            // self.ugcTypeSegmentedControl.setTitle(commentButtonText, forSegmentAt: 3)
            
            self.tableViewForComments.reloadData()
            
        }) { (error) in
            
            // error
            print(error)
            _ = SweetAlert().showAlert("Error Loading Profile", subTitle: error.description, style: .error)
            // self.spinner.removeFromSuperview()
            
        }
        
    }
    
    func loadConversationsStats(productId: String) {
        
        let request = BVProductDisplayPageRequest(productId: productId)
            .includeStatistics(.reviews)
            .includeStatistics(.questions)
        
        request.load({ (response) in
            
            self.searchedProductArray = []
            
            let product = response.result
            
            self.searchedProductArray.append(SearchedProduct(productName: product?.name ?? "NA", imageUrl: product?.imageUrl ?? "NA"))
            
            //  self.product = product
            //
            //        self.productName.text = product?.name
            //        self.totalReviewCount = product?.reviewStatistics?.totalReviewCount as? Int ?? 0
            //        self.totalQuestionCount = product?.qaStatistics?.totalQuestionCount as? Int ?? 0
            //        self.totalAnswerCount = product?.qaStatistics?.totalAnswerCount as? Int ?? 0
            //        if let url  = product?.imageUrl {
            //          self.productImage.sd_setImage(with: URL(string: url))
            //        }
            self.tableViewforProduct.reloadData()
            
        }) { (errors) in
            
            print("An error occurred: \(errors)")
            
        }
        
    }
}

