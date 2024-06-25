//
//  ConversationsSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class ReviewSubmissionTests: BVBaseStubTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey11)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(.error)
    BVSDKManager.shared().urlSessionDelegate = nil;
  }
  
  func testSubmitReviewWithPhoto() {
    let expectation =
      self.expectation(description: "testSubmitReviewWithPhoto")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewWithPhotoPreview.json",
        "testUploadablePhotoPNGSuccess.json",
        "testSubmitReviewWithPhotoSubmit.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = self.fillOutReview(.submit)
    
    review.submit({ (reviewSubmission) in
      XCTAssertTrue(reviewSubmission.formFields?.keys.count == 0)
      expectation.fulfill()
    }, failure: { (errors) in
      print(errors.description)
      for error in errors {
        let nsError = error as NSError
        print(nsError.userInfo["BVFieldErrorMessage"] ?? "")
      }
      XCTFail()
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewWithPhotoAndNetworkDelegate() {
    let mainExpectation =
      self.expectation(
        description: "testSubmitReviewWithPhotoAndNetworkDelegate")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewWithPhotoPreview.json",
        "testUploadablePhotoPNGSuccess.json",
        "testSubmitReviewWithPhotoSubmit.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = self.fillOutReview(.submit)
    
    let testDelegate = BVNetworkDelegateTestsDelegate()
    
    XCTAssertNotNil(
      testDelegate, "BVNetworkDelegateTestsDelegate is nil")
    
    testDelegate.urlSessionExpectation =
      self.expectation(description: "urlSession expectation")
    
    testDelegate.urlSessionTaskExpectation =
      self.expectation(description: "urlSessionTask expectation")
    
    BVSDKManager.shared().urlSessionDelegate = testDelegate
    
    review.submit({ (reviewSubmission) in
      XCTAssertTrue(reviewSubmission.formFields?.keys.count == 0)
      mainExpectation.fulfill()
    }, failure: { (errors) in
      print(errors.description)
      for error in errors {
        let nsError = error as NSError
        print(nsError.userInfo["BVFieldErrorMessage"] ?? "")
      }
      XCTFail()
      mainExpectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewWithPhotoPreview() {
    
    let expectation =
      self.expectation(description: "testSubmitReviewWithPhotoPreview")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewWithPhotoPreview.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = self.fillOutReview(.preview)
    
    review.submit({ (reviewSubmission) in
      // When run in Preview mode, we get the formFields that can be used for submission.
      XCTAssertTrue(reviewSubmission.formFields?.keys.count == 50)
      expectation.fulfill()
    }, failure: { (errors) in
      XCTFail()
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  let VIDEO_URL = "https://www.youtube.com/watch?v=oHg5SJYRHA0"
  let VIDEO_CAPTION = "Very videogenic"
  
  func testSubmitReviewWithVideoPreview() {
    
    let expectation =
      self.expectation(description: "testSubmitReviewWithVideoPreview")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewWithVideoPreview.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = self.fillOutReview(.preview)
    review.addVideoURL(VIDEO_URL, withCaption: VIDEO_CAPTION)
    review.submit({ (reviewSubmission) in
      // When run in Preview mode, we get the formFields that can be used for submission.
      
      XCTAssertTrue(reviewSubmission.formFields?.keys.count == 50)
      expectation.fulfill()
    }, failure: { (errors) in
      XCTFail()
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
    
    func testSubmitReviewWithFormFields() {

        let expectation = self.expectation(description: "testSubmitReviewWithFormFields")
        
        let review = BVReviewSubmission(action: .form,
                                        productId: "test1")
        
        let randomId = String(arc4random())
        review.userId = "UserId" + randomId
        
        review.submit({ (reviewSubmission) in
            
            XCTAssertNotNil(reviewSubmission.formFields)
            XCTAssertTrue(reviewSubmission.formFields?.keys.count == 50)
            expectation.fulfill()
            
        }, failure: { (errors) in
            
            XCTFail()
            expectation.fulfill()
            
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
  
  func testSubmitReviewFailure() {
    let expectation =
      self.expectation(description: "testSubmitReviewFailure")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewFailure.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = BVReviewSubmission(
      reviewTitle: "", reviewText: "", rating: 123, productId: "1000001")
    review.userNickname = "cgil"
    review.userId = BVTestUsers().loadValueForKey(key: .reviewUserId)
    review.action = .submit
    
    review.submit({ (reviewSubmission) in
      XCTFail()
      expectation.fulfill()
    }, failure: { (errors) in
      errors.forEach { print("Expected Failure Item: \($0)") }
      
      XCTAssertEqual(errors.count, 4)
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewFailureFormCodeParsing() {
    let expectation =
      self.expectation(description: "testSubmitReviewFailureFormCodeParsing")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewFailureFormCodeParsing.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = BVReviewSubmission(
      reviewTitle: "", reviewText: "", rating: 123, productId: "1000001")
    review.userNickname = "cgil"
    review.userId = BVTestUsers().loadValueForKey(key: .reviewUserId)
    review.action = .submit
    
    review.submit({ (reviewSubmission) in
      XCTFail()
      expectation.fulfill()
    }, failure: { (errors) in
      var formRequiredCount = 0
      var formDuplicateCount = 0
      var formTooHighCount = 0
      errors.forEach { error in
        let nsError = error as NSError
        let errorCodeString = nsError.userInfo[BVFieldErrorCode] as? String
        print("Error code string: \(errorCodeString ?? "empty")")
        let bvSubmissionErrorCode = nsError.bvSubmissionErrorCode()
        switch (bvSubmissionErrorCode) {
        case .formRequired:
          print("form required enum found")
          formRequiredCount = formRequiredCount + 1
        case .formDuplicate:
          print("form duplicate enum found")
          formDuplicateCount = formDuplicateCount + 1
        case .formTooHigh:
          print("form too high enum found")
          formTooHighCount = formTooHighCount + 1
        default:
          print("unknown enum")
        }
      }
      
      XCTAssertEqual(formRequiredCount, 3)
      XCTAssertEqual(formDuplicateCount, 0)
      XCTAssertEqual(formTooHighCount, 1)
      
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewFailureCodeParsing() {
    let expectation =
      self.expectation(description: "testSubmitReviewFailureCodeParsing")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewFailureCodeParsing.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let review = BVReviewSubmission(
      reviewTitle: "", reviewText: "", rating: 123, productId: "")
    review.userNickname = "cgil"
    review.userId = BVTestUsers().loadValueForKey(key: .reviewUserId)
    review.action = .submit
    
    review.submit({ (reviewSubmission) in
      XCTFail()
      expectation.fulfill()
    }, failure: { (errors) in
      var badRequestCount = 0
      errors.forEach { error in
        let nsError = error as NSError
        let bvErrorCode = nsError.bvErrorCode()
        switch (bvErrorCode) {
        case .badRequest:
          print("Found bad request")
          badRequestCount = badRequestCount + 1
        default:
          print("unknown enum found")
        }
      }
      
      XCTAssertEqual(badRequestCount, 1)
      
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewDateOfConsumerExperienceFormFields() {
    
    let configDict = ["clientId": "testcustomermobilesdk",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey6)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    
    let expectation = self.expectation(description: "testSubmitReviewDateOfConsumerExperienceFormFields")
        
    let review = BVReviewSubmission(action: .form,
                                    productId: "test1")
    
    review.submit({ (reviewSubmission) in

      XCTAssertNotNil(reviewSubmission.formFields)
      
      guard let formFields = reviewSubmission.formFields as? [String: BVFormField] else {
        XCTFail()
        expectation.fulfill()
        return
      }
      
      XCTAssertNotNil(formFields["additionalfield_DateOfUserExperience"])
      expectation.fulfill()
        
    }, failure: { (errors) in
        XCTFail()
        expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewWithDateOfConsumerExperience() {
    
    let configDict = ["clientId": "testcustomermobilesdk",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey6)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    
    let expectation = self.expectation(description: "testSubmitReviewWithDateOfConsumerExperience")
    
    let review = BVReviewSubmission(
      reviewTitle: "review title",
      reviewText: "more than 50 more than 50 more than 50 more than 50 more" +
      "than 50",
      rating: 4,
      productId: "test1")
    review.action = .submit
    review.user = BVTestUsers().loadValueForKey(key: .reviewUser)
    review.addAdditionalField("DateOfUserExperience", value: "2021-04-03") // Date of consumer experience param
    
    review.submit({ (reviewSubmission) in
      XCTAssertTrue(reviewSubmission.formFields?.keys.count == 0)
      expectation.fulfill()
    }, failure: { (errors) in
      
      print(errors.description)
      for error in errors {
        let nsError = error as NSError
        print(nsError.userInfo["BVFieldErrorMessage"] ?? "")
      }
      XCTFail()
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewWithInvalidDateOfConsumerExperience() {
    
    let configDict = ["clientId": "testcustomermobilesdk",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey6)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    
    let expectation = self.expectation(description: "testSubmitReviewWithInvalidDateOfConsumerExperience")
    
    let review = BVReviewSubmission(
      reviewTitle: "review title",
      reviewText: "more than 50 more than 50 more than 50 more than 50 more" +
      "than 50",
      rating: 4,
      productId: "test1")
    review.action = .submit
    review.user = BVTestUsers().loadValueForKey(key: .reviewUserId)
    review.addAdditionalField("DateOfUserExperience", value: "03-04-2021") // Invalid Date of consumer experience
    
    review.submit({ (reviewSubmission) in
      XCTFail("Success block should not be called.")
      expectation.fulfill()
    }, failure: { (errors) in
      
      XCTAssertEqual(errors.count, 1)
      
      let invalidDateofUXError = errors.first! as NSError
      XCTAssertEqual(invalidDateofUXError.bvSubmissionErrorCode(), .formPatternMismatch)
      XCTAssertEqual(invalidDateofUXError.userInfo["BVFieldErrorName"] as! String, "additionalfield_DateOfUserExperience")
      
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitReviewWithFutureDateOfConsumerExperience() {
    
    let configDict = ["clientId": "testcustomermobilesdk",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey12)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    
    let expectation = self.expectation(description: "testSubmitReviewWithInvalidDateOfConsumerExperience")
    
    let review = BVReviewSubmission(
      reviewTitle: "review title",
      reviewText: "more than 50 more than 50 more than 50 more than 50 more" +
      "than 50",
      rating: 4,
      productId: "test1")
    review.action = .submit
    review.user = BVTestUsers().loadValueForKey(key: .reviewUserId)
    review.userNickname = "Test09675"
    review.addAdditionalField("DateOfUserExperience", value: "2022-04-03") // Invalid Date of consumer experience
    review.agreedToTermsAndConditions = true

    review.submit({ (reviewSubmission) in
      XCTFail("Success block should not be called.")
      expectation.fulfill()
    }, failure: { (errors) in
      
      XCTAssertEqual(errors.count, 1)
      let invalidDateofUXError = errors.first! as NSError
      
      XCTAssertEqual(invalidDateofUXError.bvSubmissionErrorCode(), .formFutureDate)
      XCTAssertEqual(invalidDateofUXError.userInfo["BVFieldErrorName"] as! String, "additionalfield_DateOfUserExperience")
      
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func fillOutReview(_ action : BVSubmissionAction) -> BVReviewSubmission {
    let review = BVReviewSubmission(
      reviewTitle: "review title",
      reviewText: "more than 50 more than 50 more than 50 more than 50 more" +
      "than 50",
      rating: 4,
      productId: "test1")
    
    let randomId = String(arc4random())
    
    review.campaignId = "BV_REVIEW_DISPLAY"
    review.locale = "en_US"
    review.sendEmailAlertWhenCommented = true
    review.sendEmailAlertWhenPublished = true
    review.userNickname = "UserNickname" + randomId
    review.netPromoterScore = 5
    review.netPromoterComment = "Never!"
    review.userId = "UserId" + randomId
    review.userEmail = "developer@bazaarvoice.com"
    review.agreedToTermsAndConditions = true
    review.action = action
    
    review.addContextDataValueBool("VerifiedPurchaser", value: false)
    review.addContextDataValueString("Age", value: "18to24")
    review.addContextDataValueString("Gender", value: "Male")
    review.addRatingQuestion("Quality", value: 1)
    review.addRatingQuestion("Value", value: 3)
    review.addRatingQuestion("HowDoes", value: 4)
    review.addRatingQuestion("Fit", value: 3)
    review.addCustomSubmissionParameter("_foo", withValue: "bar")
    
    if let image = PhotoUploadTests.createPNG() {
      review.addPhoto(image, withPhotoCaption: "Very photogenic")

    }
    
    return review
  }
}
