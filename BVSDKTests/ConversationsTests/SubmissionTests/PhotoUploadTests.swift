//
//  ConversationsSubmissionTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class PhotoUploadTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "kuy3zj9pr3n7i0wxajrzj04xo"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().urlSessionDelegate = nil
  }
  
  
  func testUploadablePhotoPNGSuccessWithNetworkDelegate() {
    let mainExpectation = self.expectation(description: "")
    
    if let image = PhotoUploadTests.createPNG() {
      let photo =
        BVUploadablePhoto(photo: image, photoCaption: "Very photogenic")
      // upload photo, make sure it returns a non-empty URL
      
      let testDelegate = BVNetworkDelegateTestsDelegate()
      XCTAssertNotNil(
        testDelegate, "BVNetworkDelegateTestsDelegate is nil")
      
      testDelegate.urlSessionExpectation =
        self.expectation(description: "urlSession expectation")
      
      testDelegate.urlSessionTaskExpectation =
        self.expectation(description: "urlSessionTask expectation")
      
      BVSDKManager.shared().urlSessionDelegate = testDelegate
      
      photo.upload(for: .review, success: { (photoUrl) in
        XCTAssertTrue(photoUrl.count > 0)
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
    
    if let image = PhotoUploadTests.createPNG() {
      let photo =
        BVUploadablePhoto(photo: image, photoCaption: "Very photogenic")
      // upload photo, make sure it returns a non-empty URL
      photo.upload(for: .review, success: { (photoUrl) in
        XCTAssertTrue(photoUrl.count > 0)
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
    
    if let image = PhotoUploadTests.createJPG() {
      let photo =
        BVUploadablePhoto(photo: image, photoCaption: "Very photogenic")
      // upload photo, make sure it returns a non-empty URL
      photo.upload(for: .review, success: { (photoUrl) in
        XCTAssertTrue(photoUrl.count > 0)
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
    let photo =
      BVUploadablePhoto(
        photo: UIImage(), photoCaption: "Very photogenic")
    
    // upload photo, make sure it returns a non-empty URL
    let expectation = self.expectation(description: "")
    
    photo.upload(for: .review, success: { (photoUrl) in
      XCTFail()
      expectation.fulfill()
    }) { (errors) in
      XCTAssertEqual(errors.count, 1)
      let error = errors.first! as NSError
      XCTAssertEqual(
        error.userInfo[BVFieldErrorCode] as? String,
        "ERROR_FORM_IMAGE_PARSE")
      XCTAssertEqual(
        error.userInfo[BVFieldErrorName] as? String, "photo")
      XCTAssertEqual(
        error.userInfo[BVFieldErrorMessage] as? String,
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
