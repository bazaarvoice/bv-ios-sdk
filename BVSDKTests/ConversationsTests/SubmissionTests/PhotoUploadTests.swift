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
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey1)];
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
  
  // MARK: - Request Construction Tests
  
  private static let kAuthKeyParam = "passkey"
  private static let kApiVersionParam = "apiversion"
  
  func testPhotoUploadRequestHasAuthKeyInQueryParams() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let request = photo.generateRequest()
    guard let url = request.url,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems else {
      XCTFail("Could not parse URL from generated request")
      return
    }
    
    let authKey = queryItems.first(where: { $0.name == PhotoUploadTests.kAuthKeyParam })?.value
    XCTAssertNotNil(authKey, "auth key should be present as a query parameter")
    XCTAssertFalse(authKey?.isEmpty ?? true, "auth key should not be empty")
  }
  
  func testPhotoUploadRequestHasApiVersionInQueryParams() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let request = photo.generateRequest()
    guard let url = request.url,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems else {
      XCTFail("Could not parse URL from generated request")
      return
    }
    
    let apiversion = queryItems.first(where: { $0.name == PhotoUploadTests.kApiVersionParam })?.value
    XCTAssertEqual(apiversion, "5.4", "apiversion query param should be 5.4")
  }
  
  func testPhotoUploadRequestHasCorrectEndpoint() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let request = photo.generateRequest()
    guard let url = request.url else {
      XCTFail("Could not get URL from generated request")
      return
    }
    
    XCTAssertTrue(
      url.absoluteString.contains("uploadphoto.json"),
      "URL should contain uploadphoto.json endpoint")
  }
  
  func testPhotoUploadRequestIsPostMethod() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let request = photo.generateRequest()
    XCTAssertEqual(request.httpMethod, "POST", "Photo upload should use POST method")
  }
  
  func testPhotoUploadRequestBodyDoesNotContainAuthKey() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let params = photo.createSubmissionParameters()
    XCTAssertNil(
      params[PhotoUploadTests.kAuthKeyParam],
      "auth key should not be in the multipart body parameters")
  }
  
  func testPhotoUploadRequestBodyDoesNotContainApiVersion() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let params = photo.createSubmissionParameters()
    XCTAssertNil(
      params[PhotoUploadTests.kApiVersionParam],
      "apiversion should not be in the multipart body parameters")
  }
  
  func testPhotoUploadRequestBodyContainsContentType() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let params = photo.createSubmissionParameters()
    XCTAssertEqual(
      params["contenttype"] as? String, "review",
      "contenttype should be present in the multipart body parameters")
  }
  
  func testPhotoUploadRequestBodyContainsPhotoData() {
    guard let image = PhotoUploadTests.createPNG() else {
      XCTFail("Could not create test image")
      return
    }
    
    let photo = BVPhotoSubmission(
      photo: image,
      photoCaption: "Test caption",
      photoContentType: .review)
    
    let params = photo.createSubmissionParameters()
    XCTAssertNotNil(
      params["photo"],
      "photo data should be present in the multipart body parameters")
    XCTAssertTrue(
      params["photo"] is Data,
      "photo should be NSData")
  }
}
