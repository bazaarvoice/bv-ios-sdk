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

class SearchViewController: UIViewController {
    
    var radioButtonArray: [RadioButton] = []
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Upper: UIView!
    @IBOutlet weak var tableView: BVQuestionsTableView!
    @IBOutlet weak var tableViewForRatings: BVReviewsTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var questions : [BVQuestion] = []
    var reviews : [BVReview] = []
    
    
    
    //    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product:BVProduct?) {
    //      self.product = product!
    //      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //      fatalError("init(coder:) has not been implemented")
    //    }
    //Test
    //  private let productId : String = "test1"
    
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
    }
}

//Extension for UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let question = questions[(indexPath as NSIndexPath).section]
        
        if (indexPath as NSIndexPath).row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerTableViewCell") as! QuestionAnswerTableViewCell
            cell.question = question
            cell.onAuthorNickNameTapped = { (authorId) -> Void in
                let authorVC = AuthorProfileViewController(authorId: authorId)
                self.navigationController?.pushViewController(authorVC, animated: true)
            }
            return cell
            
        }
        else {
            
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
        
        self.loadQuestions(productId: searchBar.text ?? "")
    }
}

extension SearchViewController {
    
    func loadQuestions(productId: String) {
        
        let request = BVQuestionsAndAnswersRequest(productId: productId, limit: 20, offset: 0)
        
        self.tableView.load(request, success: { (response) in
            
            //        self.spinner.removeFromSuperview()
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
        //      // Check sorting and filter FilterOptions
        //      if selectedFilterOption == FilterOptions.highestRating.rawValue {
        //        request.sort(by: .reviewRating, monotonicSortOrderValue: .descending)
        //      } else if selectedFilterOption == FilterOptions.lowestRating.rawValue {
        //        request.sort(by: .reviewRating, monotonicSortOrderValue: .ascending)
        //      } else if selectedFilterOption == FilterOptions.mostHelpful.rawValue {
        //        request.sort(by: .reviewHelpfulness, monotonicSortOrderValue: .descending)
        //      } else if selectedFilterOption == FilterOptions.mostComments.rawValue {
        //        request.sort(by: .reviewTotalCommentCount, monotonicSortOrderValue: .descending)
        //      }
        //
        self.tableViewForRatings.load(request, success: { (response) in
            
            //self.spinner.removeFromSuperview()
            
            if (self.reviews.count == 0){
                self.reviews = response.results
            } else {
                self.reviews.append(contentsOf: response.results)
            }
            
            
            //  self.reviewFetchPending = false
            self.tableView.reloadData()
            
        })
        { (errors) in
            
            print("An error occurred: \(errors)")
            //self.reviewFetchPending = false
            
        }
        
    }
    
    
    func loadConversationsStats() {
        
        let request = BVProductDisplayPageRequest(productId: "product1")
            .includeStatistics(.reviews)
            .includeStatistics(.questions)
        
        request.load({ (response) in
            
            let product = response.result
            
            //        self.product = product
            //
            //        self.productName.text = product?.name
            //        self.totalReviewCount = product?.reviewStatistics?.totalReviewCount as? Int ?? 0
            //        self.totalQuestionCount = product?.qaStatistics?.totalQuestionCount as? Int ?? 0
            //        self.totalAnswerCount = product?.qaStatistics?.totalAnswerCount as? Int ?? 0
            //        if let url  = product?.imageUrl {
            //          self.productImage.sd_setImage(with: URL(string: url))
            //        }
            self.tableView.reloadData()
            
        }) { (errors) in
            
            print("An error occurred: \(errors)")
            
        }
        
    }
}
