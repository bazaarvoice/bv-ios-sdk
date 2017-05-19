//
//  BVSortOptionsComments.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSortOptionsComments.h"

@implementation BVSortOptionsCommentUtil

+(NSString* _Nonnull)toString:(BVSortOptionComments)commentSortOption{
    
    switch (commentSortOption) {
        case BVSortOptionCommentId: return @"Id";
        case BVSortOptionCommentAuthorId: return @"AuthorId";
        case BVSortOptionCommentCampaignId: return @"CampaignId";
        case BVSortOptionCommentContentLocale: return @"ContentLocale";
        case BVSortOptionCommentsIsFeatured: return @"IsFeatured";
        case BVSortOptionCommentsLastModeratedTime: return @"LastModeratedTime";
        case BVSortOptionCommentsLastModificationTime: return @"LastModificationTime";
        case BVSortOptionCommentsProductId: return @"ProductId";
        case BVSortOptionCommentsReviewId: return @"ReviewId";
        case BVSortOptionCommentsSubmissionId: return @"SubmissionId";
        case BVSortOptionCommentsSubmissionTime: return @"SubmissionTime";
        case BVSortOptionCommentsTotalFeedbackCount: return @"TotalFeedbackCount";
        case BVSortOptionCommentsTotalNegativeFeedbackCount: return @"TotalNegativeFeedbackCount";
        case BVSortOptionCommentsTotalPositiveFeedbackCount: return @"TotalPositiveFeedbackCount";
        case BVSortOptionCommentsUserLocation: return @"UserLocation";
    }
}

@end
