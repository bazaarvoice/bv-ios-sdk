//
//  ProductSentimentsViewModel.swift
//  BVSwiftDemo
//
//  Created by Rahul on 25/06/25.
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSDK

protocol ProductSentimentsViewModelDelegate: AnyObject {
//        var productId: String { get set }
        func getRowCount(_ type: ReviewTableSections) -> Int
        func getText(_ type: ReviewTableSections, _ row: Int) -> String
        func didSelectFeatureAtIndex(_ type: ReviewTableSections, _ row: Int)
        var productSentimentsUIDelegate: ProductSentimentsUIDelegate? { get set }
}

protocol ProductSentimentsUIDelegate: AnyObject {
    func reloadData()
}


class ProductSentimentsViewModel: ProductSentimentsViewModelDelegate {
    
    private var summarisedFeatures: BVSummarisedFeatures?
    private var reviewSummary: BVReviewSummary?
    private var productFeatures: BVProductFeatures?
    private var productQuotes: BVQuotes?
    private var featureQuotes: BVQuotes?
    private let dispatchGroup = DispatchGroup()
    
    var productSentimentsUIDelegate: ProductSentimentsUIDelegate?
    var productId: String = ""

    init(productId: String) {
        self.productId = productId
        self.dispatchGroupNotify()
        self.fetchReviewSummary()
        self.getSummarisedFeatures()
        self.getFeatures()
        self.getQuotes()
    }
    
    
    private func dispatchGroupNotify() {
        self.dispatchGroup.notify(queue: .main) {
            self.productSentimentsUIDelegate?.reloadData()
        }
    }

    private func fetchReviewSummary() {
        
        self.dispatchGroup.enter()
        let request = BVReviewSummaryRequest(productId: self.productId, formatType: BVReviewSummaryFormatType.bullet) // or BVReviewSummaryFormatType.paragraph
          
          request.load({ (response) in
              self.reviewSummary = response
              self.dispatchGroup.leave()

          }) { (error) in
              print(error)
              self.dispatchGroup.leave()
          }
    }
    
    private func getSummarisedFeatures() {
        self.dispatchGroup.enter()
        
        let request = BVSummarisedFeaturesRequest(productId: self.productId, language: "en", embed: "quotes")
        request.load({ response in
            self.summarisedFeatures = response.result
            self.dispatchGroup.leave()
        }) { (errors) in
            for error in errors {
                let sentimentsError = (error as NSError).bvProductSentimentsErrorCode()
                print(sentimentsError)
                print("product sentiments request error: \(error.localizedDescription)")
            }
            self.dispatchGroup.leave()
        }
    }
    
    func getFeatures() {
        self.dispatchGroup.enter()
        
        let request = BVProductFeaturesRequest(productId: productId, language: "en", limit: 10)
        request.load({ response in
            guard let features = response.result.features else {
                print("No features for product")
                self.dispatchGroup.leave()
                return
            }
            self.productFeatures = response.result
            self.dispatchGroup.leave()
        }) { (errors) in
            for error in errors {
                let sentimentsError = (error as NSError).bvProductSentimentsErrorCode()
                print(sentimentsError)
                print("product sentiments request error: \(error.localizedDescription)")
            }
            self.dispatchGroup.leave()
          }
    }
    
    func getQuotes() {
        self.dispatchGroup.enter()

        let request = BVProductQuotesRequest(productId: productId, language: "en", limit: 10)
          request.load({ response in
              guard let quotes = response.result.quotes else {
                  print("No quotes for product")
                  self.dispatchGroup.leave()
                  return
              }
              self.productQuotes = response.result
              self.dispatchGroup.leave()
          }) { (errors) in
              for error in errors {
                  let sentimentsError = (error as NSError).bvProductSentimentsErrorCode()
                  print(sentimentsError)
                  print("product sentiments request error: \(error)")
              }
              self.dispatchGroup.leave()
            }
    }
    
    func didSelectFeatureAtIndex(_ type: ReviewTableSections, _ index: Int) {
        self.featureQuotes = nil
        if type == .pros {
            guard let features = self.summarisedFeatures?.bestFeatures, !features.isEmpty, let quotes = features[index].embedded else { return }
            self.featureQuotes = quotes
        } else if type == .cons {
            guard let features = self.summarisedFeatures?.worstFeatures, !features.isEmpty, let quotes = features[index].embedded else { return }
            self.featureQuotes = quotes
        }
        self.productSentimentsUIDelegate?.reloadData()
    }
    
    func getRowCount(_ type: ReviewTableSections) -> Int {
        switch type {
        case .features:
            let count = self.productFeatures?.features?.count ?? 1
            return count == 0 ? 1 : count
        case .summary:
            return 1
        case .pros:
            let count = self.summarisedFeatures?.bestFeatures?.count ?? 1
            return count == 0 ? 1 : count
        case .cons:
            let count = self.summarisedFeatures?.worstFeatures?.count ?? 1
            return count == 0 ? 1 : count
        case .positiveQuotes:
            return self.summarisedFeatures?.bestFeatures?.first?.embedded?.quotes?.count ?? 0
        case .negativeQuotes:
            return self.summarisedFeatures?.worstFeatures?.first?.embedded?.quotes?.count ?? 0
        case .featureQuotes:
            let count = self.featureQuotes?.quotes?.count ?? 1
            return count == 0 ? 1 : count
        case .quotes:
            let count = self.productQuotes?.quotes?.count ?? 1
            return count == 0 ? 1 : count
        default:
            return 0
        }
    }
    
    func getText(_ type: ReviewTableSections, _ row: Int) -> String {
        switch type {
        case .features:
            guard let feature = self.productFeatures?.features, !feature.isEmpty else {
                return "No features available yet"
            }
            return feature[row].feature ?? ""
        case .summary:
            return self.reviewSummary?.summary ?? "No summary available yet"
        case .pros:
            guard let pros = self.summarisedFeatures?.bestFeatures, !pros.isEmpty else {
                return "No pros available yet"
            }
            return pros[row].feature ?? ""
        case .cons:
            guard let cons = self.summarisedFeatures?.worstFeatures, !cons.isEmpty else {
                return "No cons available yet"
            }
            return cons[row].feature ?? ""
        case .positiveQuotes:
            return self.summarisedFeatures?.bestFeatures?.first?.embedded?.quotes?[row].text ?? ""
        case .negativeQuotes:
            return self.summarisedFeatures?.worstFeatures?.first?.embedded?.quotes?[row].text ?? ""
        case .featureQuotes:
            guard let quotes = self.featureQuotes?.quotes, !quotes.isEmpty else {
                return "Select a Pro or Con to see quotes"
            }
            return quotes[row].text ?? ""
        case .quotes:
            guard let quotes = self.productQuotes?.quotes, !quotes.isEmpty else {
                return "No quotes available yet"
            }
            return quotes[row].text ?? ""
        default:
            return ""
        }
    }
}
