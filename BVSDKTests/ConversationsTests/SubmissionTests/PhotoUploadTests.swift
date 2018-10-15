//
//  ConversationsSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class PhotoUploadTests: BVBaseStubTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().urlSessionDelegate = nil
  }
  
  
  func testUploadablePhotoPNGSuccessWithNetworkDelegate() {
    let mainExpectation = self.expectation(description: "")
    
    let sequenceFiles:[String] =
      [
        "testUploadablePhotoPNGSuccess.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    if let image = PhotoUploadTests.createPNG() {
      let photo =
        BVPhotoSubmission(
          photo: image,
          photoCaption: "Very photogenic",
          photoContentType: .answer)
      // upload photo, make sure it returns a non-empty URL
      
      let testDelegate = BVNetworkDelegateTestsDelegate()
      XCTAssertNotNil(
        testDelegate, "BVNetworkDelegateTestsDelegate is nil")
      
      testDelegate.urlSessionExpectation =
        self.expectation(description: "urlSession expectation")
      
      testDelegate.urlSessionTaskExpectation =
        self.expectation(description: "urlSessionTask expectation")
      
      BVSDKManager.shared().urlSessionDelegate = testDelegate
      
      photo.submit({ (photoSubmissionResponse) in
        XCTAssertNotNil(photoSubmissionResponse.result)
        mainExpectation.fulfill()
      }) { (errors) in
        XCTFail()
        mainExpectation.fulfill()
      }
      
    } else {
      mainExpectation.fulfill()
      XCTFail()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testUploadablePhotoPNGSuccess() {
    let expectation = self.expectation(description: "")
    
    let sequenceFiles:[String] =
      [
        "testUploadablePhotoPNGSuccess.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    if let image = PhotoUploadTests.createPNG() {
      let photo =
        BVPhotoSubmission(
          photo: image,
          photoCaption: "Very photogenic",
          photoContentType: .answer)
      // upload photo, make sure it returns a non-empty URL
      photo.submit({ (photoSubmissionResponse) in
        XCTAssertNotNil(photoSubmissionResponse.result)
        expectation.fulfill()
      }) { (errors) in
        XCTFail()
        expectation.fulfill()
      }
      
    } else {
      expectation.fulfill()
      XCTFail()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testUploadablePhotoJPGTooLargeSuccess() {
    let expectation = self.expectation(description: "")
    
    let sequenceFiles:[String] =
      [
        "testUploadablePhotoJPGTooLargeSuccess.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    if let image = PhotoUploadTests.createJPG() {
      let photo =
        BVPhotoSubmission(
          photo: image,
          photoCaption: "Very photogenic",
          photoContentType: .answer)
      // upload photo, make sure it returns a non-empty URL
      photo.submit({ (photoSubmissionResponse) in
        XCTAssertNotNil(photoSubmissionResponse.result)
        expectation.fulfill()
      }) { (errors) in
        XCTFail()
        expectation.fulfill()
      }
      
    } else {
      expectation.fulfill()
      XCTFail()
    }
    
    waitForExpectations(timeout: 30, handler: nil)
  }
  
  func testUploadablePhotoFailure() {
    
    // upload photo, make sure it returns a non-empty URL
    let expectation = self.expectation(description: "testUploadablePhotoFailure")
    
    guard let image = PhotoUploadTests.createJPG() else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let photo =
      BVPhotoSubmission(
        photo: image,
        photoCaption: "Very photogenic",
        photoContentType: .answer)
    
    let sequenceFiles:[String] =
      [
        "testUploadablePhotoFailure.json"
    ]
    forceStub(withJSONSequence: sequenceFiles)
    
    photo.submit({ (photoSubmissionResponse) in
      XCTFail()
      expectation.fulfill()
    }) { (errors) in
      XCTAssertEqual(errors.count, 1)
      
      guard let firstError = errors.first else {
        XCTFail()
        expectation.fulfill()
        return
      }
      
      let error = firstError as NSError
      
      guard let errCode = error.userInfo[BVFieldErrorCode] as? String,
        let errName = error.userInfo[BVFieldErrorName] as? String,
        let errMsg = error.userInfo[BVFieldErrorMessage] as? String else {
          XCTFail()
          expectation.fulfill()
          return
      }
      
      XCTAssertEqual(errCode, "ERROR_FORM_IMAGE_PARSE")
      XCTAssertEqual(errName, "photo")
      XCTAssertEqual(errMsg,
                     "We were unable to parse the image you uploaded.  " +
                      "Please ensure that the image is a valid BMP, PNG, " +
        "GIF or JPEG file.")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  class func createPNG() -> UIImage? {
    return UIImage(
      named: "ph.png",
      in: Bundle(for: PhotoUploadTests.self),
      compatibleWith: nil)
  }
  
  class func createJPG() -> UIImage? {
    return UIImage(
      named: "skelly_android.jpg",
      in: Bundle(for: PhotoUploadTests.self),
      compatibleWith: nil)
  }
}
