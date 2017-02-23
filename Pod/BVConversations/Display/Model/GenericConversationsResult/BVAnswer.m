//
//  BVAnswer.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVAnswer

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse includes:(BVConversationsInclude* _Nullable)includes {
    self = [super init];
    if(self){
        SET_IF_NOT_NULL(self.userNickname, apiResponse[@"UserNickname"])
        SET_IF_NOT_NULL(self.submissionId, apiResponse[@"SubmissionId"])
        SET_IF_NOT_NULL(self.questionId, apiResponse[@"QuestionId"])
        SET_IF_NOT_NULL(self.totalFeedbackCount, apiResponse[@"TotalFeedbackCount"])
        SET_IF_NOT_NULL(self.totalPositiveFeedbackCount, apiResponse[@"TotalPositiveFeedbackCount"])
        SET_IF_NOT_NULL(self.userLocation, apiResponse[@"UserLocation"])
        SET_IF_NOT_NULL(self.authorId, apiResponse[@"AuthorId"])
        SET_IF_NOT_NULL(self.isFeatured, apiResponse[@"IsFeatured"])
        SET_IF_NOT_NULL(self.productRecommendationIds, apiResponse[@"ProductRecommendationIds"])
        SET_IF_NOT_NULL(self.additionalFields, apiResponse[@"AdditionalFields"])
        SET_IF_NOT_NULL(self.campaignId, apiResponse[@"CampaignId"])
        SET_IF_NOT_NULL(self.brandImageLogoURL, apiResponse[@"BrandImageLogoURL"])
        SET_IF_NOT_NULL(self.totalNegativeFeedbackCount, apiResponse[@"TotalNegativeFeedbackCount"])
        SET_IF_NOT_NULL(self.contentLocale, apiResponse[@"ContentLocale"])
        SET_IF_NOT_NULL(self.moderationStatus, apiResponse[@"ModerationStatus"])
        SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
        SET_IF_NOT_NULL(self.answerText, apiResponse[@"AnswerText"])
        
        self.lastModificationTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"LastModificationTime"]];
        self.submissionTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"SubmissionTime"]];
        self.lastModeratedTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"LastModeratedTime"]];
        
        self.photos = [BVModelUtil parsePhotos:apiResponse[@"Photos"]];
        self.videos = [BVModelUtil parseVideos:apiResponse[@"Videos"]];
        self.badges = [BVModelUtil parseBadges:apiResponse[@"Badges"]];
        self.contextDataValues = [BVModelUtil parseContextDataValues:apiResponse[@"ContextDataValues"]];

    }
    return self;
}


-(void)recordTap {
    // no 'user tapped' action for answers yet
}

@end
