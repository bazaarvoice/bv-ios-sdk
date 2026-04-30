//
//  VideoUploadTests.swift
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class VideoUploadTests: BVBaseStubTestCase {
    
    private static let kAuthKeyParam = "PassKey"
    private static let kApiVersionParam = "ApiVersion"
    private static let kContentType = "contentType"

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
    
    // MARK: - Request Construction Tests
    
    func testVideoUploadRequestHasAuthKeyInQueryParams() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let request = video.generateRequest()
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            XCTFail("Could not parse URL from generated request")
            return
        }
        
        let authKey = queryItems.first(where: { $0.name == VideoUploadTests.kAuthKeyParam })?.value
        XCTAssertNotNil(authKey, "auth key should be present as a query parameter")
        XCTAssertFalse(authKey?.isEmpty ?? true, "auth key should not be empty")
    }
    
    func testVideoUploadRequestHasApiVersionInQueryParams() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let request = video.generateRequest()
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            XCTFail("Could not parse URL from generated request")
            return
        }
        
        let apiversion = queryItems.first(where: { $0.name == VideoUploadTests.kApiVersionParam })?.value
        XCTAssertEqual(apiversion, "5.4", "apiversion query param should be 5.4")
    }
    
    func testVideoUploadRequestHasContentTypeInQueryParams() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        
        let request = video.generateRequest()
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            XCTFail("Could not parse URL from generated request")
            return
        }
        
        let contentType = queryItems.first(where: { $0.name == VideoUploadTests.kContentType })?.value
        XCTAssertEqual(contentType, "review", "contentType query param should be review")
    }
    
    func testVideoUploadRequestHasCorrectEndpoint() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let request = video.generateRequest()
        guard let url = request.url else {
            XCTFail("Could not get URL from generated request")
            return
        }
        
        XCTAssertTrue(
            url.absoluteString.contains("uploadvideo.json"),
            "URL should contain uploadvideo.json endpoint")
    }
    
    func testVideoUploadRequestIsPostMethod() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let request = video.generateRequest()
        XCTAssertEqual(request.httpMethod, "POST", "Video upload should use POST method")
    }
    
    func testVideoUploadRequestBodyDoesNotContainAuthKey() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let params = video.createSubmissionParameters()
        XCTAssertNil(
            params[VideoUploadTests.kAuthKeyParam],
            "auth key should not be in the multipart body parameters")
    }
    
    func testVideoUploadRequestBodyDoesNotContainApiVersion() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let params = video.createSubmissionParameters()
        XCTAssertNil(
            params[VideoUploadTests.kApiVersionParam],
            "apiversion should not be in the multipart body parameters")
    }
    
    func testVideoUploadRequestBodyContainsVideoData() {
        guard let videoPath = VideoUploadTests.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideoSubmission(
            video: videoPath,
            videoCaption: "Test Video",
            uploadVideo: true,
            videoContentType: .review)
        
        let params = video.createSubmissionParameters()
        XCTAssertNotNil(
            params["Video"],
            "video data should be present in the multipart body parameters")
        XCTAssertTrue(
            params["Video"] is Data,
            "video should be NSData")
    }
    
}
