//
//  Review.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReview.h"
#import "BVModelUtil.h"
#import "BVConversationsInclude.h"
#import "BVConversationsAnalyticsUtil.h"
#import "BVProduct.h"
#import "BVNullHelper.h"

@implementation BVReview


-(void)recordTap {
    //TODO
}

-(id)initWithApiResponse:(NSDictionary *)apiResponse includes:(BVConversationsInclude *)includes {
    self = [super init];
    if(self){
        
        
        NSString* productId = apiResponse[@"ProductId"];
        self.product = [includes getProductById:productId];
        self.cons = apiResponse[@"Cons"];
        
        NSNumber* recommended = apiResponse[@"IsRecommended"];
        if(![recommended isKindOfClass:[NSNull class]]) {
            self.isRecommended = [recommended boolValue];
        }
        
        NSNumber* ratingsOnly = apiResponse[@"IsRatingsOnly"];
        if(![ratingsOnly isKindOfClass:[NSNull class]]) {
            self.isRatingsOnly = [ratingsOnly boolValue];
        }
        
        NSNumber* featured = apiResponse[@"IsFeatured"];
        if(![featured isKindOfClass:[NSNull class]]) {
            self.isFeatured = [featured boolValue];
        }
        
        SET_IF_NOT_NULL(self.userNickname, apiResponse[@"UserNickname"])
        SET_IF_NOT_NULL(self.pros, apiResponse[@"Pros"])
        SET_IF_NOT_NULL(self.submissionId, apiResponse[@"SubmissionId"])
        SET_IF_NOT_NULL(self.totalFeedbackCount, apiResponse[@"TotalFeedbackCount"])
        SET_IF_NOT_NULL(self.totalPositiveFeedbackCount, apiResponse[@"TotalPositiveFeedbackCount"])
        SET_IF_NOT_NULL(self.userLocation, apiResponse[@"UserLocation"])
        SET_IF_NOT_NULL(self.authorId, apiResponse[@"AuthorId"])
        SET_IF_NOT_NULL(self.productId, apiResponse[@"ProductId"])
        SET_IF_NOT_NULL(self.title, apiResponse[@"Title"])
        SET_IF_NOT_NULL(self.productRecommendationIds, apiResponse[@"ProductRecommendationIds"])
        SET_IF_NOT_NULL(self.additionalFields, apiResponse[@"AdditionalFields"])
        SET_IF_NOT_NULL(self.campaignId, apiResponse[@"CampaignId"])
        SET_IF_NOT_NULL(self.helpfulness, apiResponse[@"Helpfulness"])
        SET_IF_NOT_NULL(self.totalNegativeFeedbackCount, apiResponse[@"TotalNegativeFeedbackCount"])
        
        NSNumber* num = apiResponse[@"Rating"];
        if (num && [num isKindOfClass:[NSNumber class]]) {
            self.rating = (int)[num integerValue];
        }
        else {
            self.rating = 0;
        }
        
        
        SET_IF_NOT_NULL(self.contentLocale, apiResponse[@"ContentLocale"])
        SET_IF_NOT_NULL(self.ratingRange, apiResponse[@"RatingRange"])
        SET_IF_NOT_NULL(self.totalCommentCount, apiResponse[@"TotalCommentCount"])
        SET_IF_NOT_NULL(self.reviewText, apiResponse[@"ReviewText"])
        SET_IF_NOT_NULL(self.moderationStatus, apiResponse[@"ModerationStatus"])
        SET_IF_NOT_NULL(self.clientResponses, apiResponse[@"ClientResponses"])
        SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
        
        self.lastModificationTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"LastModificationTime"]];
        self.submissionTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"SubmissionTime"]];
        self.lastModeratedTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"LastModeratedTime"]];
        
        self.tagDimensions = [BVModelUtil parseTagDimension:apiResponse[@"TagDimensions"]];
        self.photos = [BVModelUtil parsePhotos:apiResponse[@"Photos"]];
        self.videos = [BVModelUtil parseVideos:apiResponse[@"Videos"]];
        self.contextDataValues = [BVModelUtil parseContextDataValues:apiResponse[@"ContextDataValues"]];
        self.badges = [BVModelUtil parseBadges:apiResponse[@"Badges"]];
        self.secondaryRatings = [BVModelUtil parseSecondaryRatings:apiResponse[@"SecondaryRatings"]];
    }
    return self;
}

@end
