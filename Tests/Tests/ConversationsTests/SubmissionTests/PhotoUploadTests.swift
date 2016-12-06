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
        
        BVSDKManager.shared().clientId = "apitestcustomer"
        BVSDKManager.shared().apiKeyConversations = "KEY_REMOVED"
        BVSDKManager.shared().staging = true
        
    }

    
    func testUploadablePhoto() {
        
        if let image = PhotoUploadTests.createImage() {
            let photo = BVUploadablePhoto(photo: image, photoCaption: "Yo dawhhhh")
            // upload photo, make sure it returns a non-empty URL
            let expectation = self.expectation(description: "")
            photo.upload(for: .review, success: { (photoUrl) in
                XCTAssertTrue(photoUrl.characters.count > 0)
                expectation.fulfill()
            }) { (errors) in
                XCTFail()
                expectation.fulfill()
            }

        } else {
            XCTFail()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func testUploadablePhotoFailure() {
        let photo = BVUploadablePhoto(photo: UIImage(), photoCaption: "Yo dawhhhh")
        
        // upload photo, make sure it returns a non-empty URL
        let expectation = self.expectation(description: "")
        
        photo.upload(for: .review, success: { (photoUrl) in
            XCTFail()
            expectation.fulfill()
        }) { (errors) in
            XCTAssertEqual(errors.count, 1)
            let error = errors.first as! NSError
            XCTAssertEqual(error.userInfo[BVFieldErrorCode] as? String, "ERROR_FORM_IMAGE_PARSE")
            XCTAssertEqual(error.userInfo[BVFieldErrorName] as? String, "photo")
            XCTAssertEqual(error.userInfo[BVFieldErrorMessage] as? String, "We were unable to parse the image you uploaded.  Please ensure that the image is a valid BMP, PNG, GIF or JPEG file.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    class func createImage() -> UIImage? {
        let url = URL(string: "https://curations-imaging.nexus.bazaarvoice.com/?url=https%3A%2F%2Fscontent.cdninstagram.com%2Ft51.2885-15%2Fe35%2F11386449_1613048222276225_595963246_n.jpg&checksum=517c1f17&width=600&height=600&exact=true")
        if let data = try? Data(contentsOf: url!){
            return UIImage(data: data)!
        }
        
        return nil
        
    }
    
}
