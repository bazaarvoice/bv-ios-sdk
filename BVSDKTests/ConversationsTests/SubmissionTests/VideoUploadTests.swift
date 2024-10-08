//
//  VideoUploadTests.swift
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class VideoUploadTests: BVBaseStubTestCase {
    
    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "apitestcustomer",
                          "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey1)];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().urlSessionDelegate = nil
    }
    
    class func getVideoPath() -> String? {
        let bundle = Bundle(for: VideoUploadTests.self)
        guard let videoPath = bundle.path(forResource: "testVideo", ofType: "mp4")
        else {
            return nil
        }
        return videoPath
    }
    
    
    func testUploadVideoFailure() throws {
        let bundle = Bundle(for: VideoUploadTests.self)
        guard let path = bundle.path(forResource: "invalidVideoName", ofType: "mp4")
        else {
            debugPrint("video not found")
            return
        }
        debugPrint(path)
        XCTFail()
    }
    
    func testUploadVideo() {
        
        let expectation = self.expectation(description: "testUploadVideo")
        
        guard let videoPath = VideoUploadTests.getVideoPath()
        else {
            debugPrint("testVideo.mp4 not found")
            XCTFail()
            expectation.fulfill()
            return
        }
        
        let video = BVVideoSubmission(video: videoPath, videoCaption: "Test Video", uploadVideo: true, videoContentType: .review)
        video.submit({ (videoSubmissionResponse) in
          XCTAssertNotNil(videoSubmissionResponse.result)
          XCTAssertNotNil(videoSubmissionResponse.result?.video.videoUrl)
          expectation.fulfill()
        }) { (errors) in
          XCTFail()
          expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
      }
    
}
