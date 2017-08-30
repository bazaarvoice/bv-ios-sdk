//
//  ProfileDisplayTests.swift
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

// Tests conforming to API description at: https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/profiles/display
class ProfileDisplayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let configDict = ["clientId": "conciergeapidocumentation",
                          "apiKeyConversations": "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicProfile() {
        
         let expectation = self.expectation(description: "testBasicProfile")
        
        let request = BVAuthorRequest(authorId: "data-gen-user-poaouvr127us1ijhpafkfacb9");
        
        request.load({ (response) in
            // success
            
            expectation.fulfill()
            
            let profile = response.results.first!
            
            XCTAssertEqual(response.limit, 1)
            XCTAssertEqual(response.offset, 0)
            XCTAssertEqual(response.locale, "en_US")
            XCTAssertEqual(response.totalResults, 1)
            
            // Check profile data from the result
            XCTAssertEqual(profile.userNickname, "ferdinand255")
            XCTAssertEqual(profile.submissionId, nil)
            XCTAssertEqual(profile.badges.count, 2)
            XCTAssertEqual(profile.photos.count, 0)
            XCTAssertEqual(profile.videos.count, 0)
            XCTAssertEqual(profile.contextDataValues.count, 0)
            XCTAssertEqual(profile.userLocation, nil)
            
            XCTAssertEqual(profile.submissionTime, BVModelUtil.convertTimestamp(toDatetime: "2016-01-06T11:52:00.000+00:00"))
        
            let year : Int = NSCalendar.current.component(Calendar.Component.year, from: profile.lastModeratedTime!)
            XCTAssertTrue(year >= 2017)
            
            // Check the badges
            for badge in profile.badges {
                
                if badge.identifier == "Staff" {
                    XCTAssertEqual(badge.badgeType, BVBadgeType.affiliation)
                } else if badge.identifier == "Expert" {
                    XCTAssertEqual(badge.badgeType, BVBadgeType.rank)
                }
            }
            
            // Stats are nil w/out the Stats flag added
            XCTAssertEqual(profile.qaStatistics, nil)
            XCTAssertEqual(profile.reviewStatistics, nil)
            
            // Check the includes
            XCTAssertEqual(profile.includedReviews.count, 0)
            XCTAssertEqual(profile.includedQuestions.count, 0)
            
            }) { (error) in
                
            XCTFail("profile display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    
    func testAuthorStatisticsAndIncludes() {
        
        let expectation = self.expectation(description: "testAuthorStatisticsAndIncludes")
        
        let request = BVAuthorRequest(authorId: "data-gen-user-poaouvr127us1ijhpafkfacb9")
            // stats includes
            .includeStatistics(.answers)
            .includeStatistics(.questions)
            .includeStatistics(.reviews)
            //.includeStatistics(.reviewComments) // This is not supported by API, so will assert.
            
            // other includes
            .include(.reviews, limit: 10)
            .include(.questions, limit: 10)
            .include(.answers, limit: 10)
            .include(.reviewComments, limit: 10)
            
            // sorts
            .sortIncludedAnswers(.submissionTime, order: .descending)
            .sortIncludedReviews(.submissionTime, order: .descending)
            .sortIncludedQuestions(.submissionTime, order: .descending)
        
        request.load({ (response) in
            // success
            
            expectation.fulfill()
            
            let profile = response.results.first!
            
            // QA Statistics
            XCTAssertEqual(profile.qaStatistics?.totalAnswerCount, 33)
            XCTAssertEqual(profile.qaStatistics?.totalQuestionCount, 37)
            XCTAssertEqual(profile.qaStatistics?.answerHelpfulVoteCount, 0)
            XCTAssertEqual(profile.qaStatistics?.helpfulVoteCount, 0)
            XCTAssertEqual(profile.qaStatistics?.answerHelpfulVoteCount, 0)
            XCTAssertEqual(profile.qaStatistics?.questionHelpfulVoteCount, 0)
            XCTAssertEqual(profile.qaStatistics?.answerNotHelpfulVoteCount, 0)
            XCTAssertEqual(profile.qaStatistics?.questionNotHelpfulVoteCount, 0)
            
            // Review Statistics
            XCTAssertEqual(profile.reviewStatistics?.totalReviewCount, 23)
            XCTAssertEqual(profile.reviewStatistics?.helpfulVoteCount, 66)
            XCTAssertEqual(profile.reviewStatistics?.notHelpfulVoteCount, 58)
            XCTAssertEqual(profile.reviewStatistics?.notRecommendedCount, 1)
            XCTAssertEqual(profile.reviewStatistics?.overallRatingRange, 5)
            XCTAssertEqual(profile.reviewStatistics?.ratingDistribution?.fiveStarCount, 7)
            XCTAssertEqual(profile.reviewStatistics?.ratingDistribution?.fourStarCount, 16)
            XCTAssertEqual(profile.reviewStatistics?.recommendedCount, 16)
            XCTAssertEqual(String(format: "%.2f", (profile.reviewStatistics?.averageOverallRating?.floatValue)!), "4.30")
            
            // Check the includes
            XCTAssertEqual(profile.includedReviews.count, 10)
            XCTAssertEqual(profile.includedQuestions.count, 10)
            XCTAssertEqual(profile.includedAnswers.count, 10)
            XCTAssertEqual(profile.includedComments.count, 10)
            
        }) { (error) in
            
            XCTFail("profile display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }

    
    func testProfileDisplayFailure() {
        let configDict = ["clientId": "conciergeapidocumentation",
                          "apiKeyConversations": "badkey"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        
        let expectation = self.expectation(description: "testDisplayFailure")
        
        let request = BVAuthorRequest(authorId: "badauthorid")
        
        request.load({ (response) in
            // success
            XCTFail("success block should not be called")
            expectation.fulfill()
            
        }) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
   
}
