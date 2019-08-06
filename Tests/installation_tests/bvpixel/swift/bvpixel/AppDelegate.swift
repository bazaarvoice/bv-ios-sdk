//
//  AppDelegate.swift
//  bvpixel
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        BVAnalyticEventManager.shared().clientId = "myClientId"
        
        // PageView --------------------------
        let pageViewEvent = BVPageViewEvent(productId: "123",
                                with: .conversationsReviews,
                                withBrand: "myBrand",
                                withCategoryId: "optionalCategoryId",
                                withRootCategoryId: "optionalRootCategory",
                                withAdditionalParams: ["numReviews":"57","numQuestions":"3"])
        
        
        print("---------------\nPageView Event\n---------------")
        pageViewEvent.toRaw().forEach { print("\($0): \($1)") }
        
        
        // InView Event ------------------
        let inViewEvent = BVInViewEvent(productId: "123",
                                        withBrand: "optionalBrand",
                                        with: .conversationsQuestionAnswer,
                                        withContainerId: "QuestionsViewController",
                                        withAdditionalParams: nil)
        
        print("---------------\nInView Event\n---------------")
        inViewEvent.toRaw().forEach { print("\($0): \($1)") }

        
        // FeatureUsed Event ------------------
        let featureUsedEvent = BVFeatureUsedEvent(productId: "123",
                                          withBrand: "optionalBrand",
                                          with: .conversationsReviews,
                                          with: .eventNameWriteReview,
                                          withAdditionalParams: ["fingerprinting":"true"])
        
        print("---------------\nFeatureUsed Event\n---------------")
        featureUsedEvent.toRaw().forEach { print("\($0): \($1)") }

        
        
        // Impression --------------------------
        let impressionEvent = BVImpressionEvent(productId: "productId",
                                withContentId: "optionalContentId",
                                withCategoryId: "optionalCategoryId",
                                with: .conversationsQuestionAnswer,
                                with: .typeAnswer,
                                withBrand: "optionalBrand",
                                withAdditionalParams: nil)
        
        print("---------------\nImpression Event\n---------------")
        impressionEvent.toRaw().forEach { print("\($0): \($1)") }
        
        
        // ViewedCGC --------------------------
        let viewedCGC = BVViewedCGCEvent(productId: "productId",
                                         withRootCategoryID: "rootCatId",
                                         withCategoryId: "catId",
                                         with: .conversationsQuestionAnswer,
                                         withBrand: "brandName",
                                         withAdditionalParams: nil)
        
        print("---------------\nViewedCGC Event\n---------------")
        viewedCGC.toRaw().forEach { print("\($0): \($1)") }
        
        // Transaction --------------------------
        let transactionItem1 = BVTransactionItem(sku: "sku",
                                                 name: "product name",
                                                 category: "product category",
                                                 price: 9.99,
                                                 quantity: 2,
                                                 imageUrl: nil)
        let transactionItem2 = BVTransactionItem(sku: "sku2",
                                                 name: "product name2",
                                                 category: "product category",
                                                 price: 6.99,
                                                 quantity: 3,
                                                 imageUrl: nil)
        
        let transaction = BVTransactionEvent(orderId: "orderID123",
                                             orderTotal: 43.33,
                                             orderItems: [transactionItem1, transactionItem2],
                                             andOtherParams: ["email":"foo@bar.com"])
        
        print("---------------\nTransaction Event : With PII\n---------------")
        transaction.toRaw().forEach { print("\($0): \($1)") }
        
        print("---------------\nTransaction Event : NO PII\n---------------")
        transaction.toRawNonPII().forEach { print("\($0): \($1)") }
        
        return true
    }


}

