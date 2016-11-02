//
//  BVSDKDemoTests.swift
//  BVSDKDemoTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest








class BVSDKDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testExample() {
        
        do {
            let data = exampleResponse.data(using: String.Encoding.utf8)
            let responseObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            let response = ConversationsResponse<Review>(apiResponse: responseObject)
            
            print("response: \(response)")
            print()
        } catch {
            XCTFail()
        }
        
    }
    
    let exampleResponse = "{\"Includes\":{\"Products\":{\"5089900\":{\"FamilyIds\":[],\"TotalReviewCount\":40,\"QuestionIds\":[],\"Brand\":{},\"Attributes\":{},\"ReviewIds\":[],\"Name\":\"Deadpool (Only @ Best Buy) (SteelBook) (Blu-ray) (Digital HD Copy)\",\"ISBNs\":[],\"EANs\":[],\"BrandExternalId\":null,\"AttributesOrder\":[],\"Id\":\"5089900\",\"Description\":\"Deadpool (Only @ Best Buy) (SteelBook) (Blu-ray) (Digital HD Copy)\",\"CategoryId\":\"cat02015\",\"StoryIds\":[],\"UPCs\":[\"024543275824\"],\"ReviewStatistics\":{\"RecommendedCount\":40,\"FirstSubmissionTime\":\"2016-03-20T20:11:38.000+00:00\",\"RatingDistribution\":[{\"Count\":1,\"RatingValue\":2},{\"Count\":1,\"RatingValue\":3},{\"Count\":3,\"RatingValue\":4},{\"Count\":35,\"RatingValue\":5}],\"FeaturedReviewCount\":0,\"RatingsOnlyReviewCount\":0,\"OverallRatingRange\":5,\"TotalReviewCount\":40,\"NotRecommendedCount\":0,\"TagDistributionOrder\":[],\"SecondaryRatingsAverages\":{},\"NotHelpfulVoteCount\":127,\"TagDistribution\":{},\"ContextDataDistributionOrder\":[\"rewardZoneMembershipV3\",\"ReadReviews\"],\"HelpfulVoteCount\":102,\"AverageOverallRating\":4.8,\"SecondaryRatingsAveragesOrder\":[],\"ContextDataDistribution\":{\"ReadReviews\":{\"Label\":\"Did you read product reviews online before first purchasing this item?\",\"Id\":\"ReadReviews\",\"Values\":[{\"Value\":\"Yes\",\"Count\":16},{\"Value\":\"No\",\"Count\":23}]},\"rewardZoneMembershipV3\":{\"Label\":\"fdsfds\",\"Id\":\"rewardZoneMembershipV3\",\"Values\":[{\"Value\":\"Yes\",\"Count\":22},{\"Value\":\"Yes-EL\",\"Count\":9},{\"Value\":\"Yes-PS\",\"Count\":4},{\"Value\":\"No\",\"Count\":4}]}},\"LastSubmissionTime\":\"2016-05-12T19:18:42.000+00:00\"},\"ManufacturerPartNumbers\":[],\"ImageUrl\":\"http://img.bbystatic.com/BestBuy_US/images/products/5089/5089900_sa.jpg\",\"ModelNumbers\":[],\"ProductPageUrl\":\"http://www.bestbuy.com/site/deadpool-only--best-buy-steelbook-blu-ray-digital-hd-copy/5089900.p?id=3555122&skuId=5089900&cmp=RMX\"}},\"ProductsOrder\":[\"5089900\"]},\"Offset\":0,\"Locale\":\"en_US\",\"HasErrors\":false,\"Errors\":[],\"Results\":[{\"IsSyndicated\":false,\"SubmissionId\":\"kxugpufx15y2lqbtnho5lfu5e\",\"SecondaryRatings\":{},\"ContentLocale\":\"en_US\",\"TagDimensionsOrder\":[],\"ContextDataValues\":{},\"LastModificationTime\":\"2016-05-12T19:45:09.000+00:00\",\"Pros\":null,\"IsFeatured\":false,\"TotalPositiveFeedbackCount\":0,\"ProductRecommendationIds\":[],\"ContextDataValuesOrder\":[],\"IsRecommended\":true,\"UserLocation\":null,\"AdditionalFieldsOrder\":[\"RewardZoneNumber\"],\"ReviewText\":\"One of my favorite steelbooks. The upside spine is ironic cause it's deadpool.\",\"BadgesOrder\":[\"rewardZoneNumberV3\"],\"TotalCommentCount\":0,\"LastModeratedTime\":\"2016-05-12T19:45:09.000+00:00\",\"SecondaryRatingsOrder\":[],\"RatingRange\":5,\"SubmissionTime\":\"2016-05-12T19:18:42.000+00:00\",\"TotalFeedbackCount\":0,\"Videos\":[],\"TotalNegativeFeedbackCount\":0,\"ProductId\":\"5089900\",\"Title\":\"I love this movie\",\"ModerationStatus\":\"APPROVED\",\"ClientResponses\":[],\"UserNickname\":\"Que28\",\"Photos\":[],\"TagDimensions\":{},\"AuthorId\":\"ATG19471375678\",\"Cons\":null,\"Badges\":{\"rewardZoneNumberV3\":{\"ContentType\":\"REVIEW\",\"BadgeType\":\"Custom\",\"Id\":\"rewardZoneNumberV3\"}},\"Rating\":5,\"Helpfulness\":null,\"IsRatingsOnly\":false,\"CampaignId\":\"BV_RATING_OVERVIEW\",\"AdditionalFields\":{\"RewardZoneNumber\":{\"Value\":\"2811444394\",\"Label\":\"My Best Buy number\",\"Id\":\"RewardZoneNumber\"}},\"Id\":\"88127242\",\"CommentIds\":[]}],\"TotalResults\":40,\"Limit\":20}"
    
}
