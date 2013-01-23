//
//  BVPost.m
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 11/26/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVPost.h"
#import "BVSettings.h"
#import "BVNetwork.h"

@interface BVPost()
@property (weak) BVNetwork *network;
@end

@implementation BVPost

@synthesize delegate = _delegate;
@synthesize type = _type;
@synthesize requestURL = _requestURL;
@synthesize action = _action;
@synthesize agreedToTermsAndConditions = _agreedToTermsAndConditions;
@synthesize sendEmailAlertWhenPublished = _sendEmailAlertWhenPublished;
@synthesize isRecommended = _isRecommended;
@synthesize isUserAnonymous = _isUserAnonymous;

@synthesize netPromoterScore = _netPromoterScore;
@synthesize rating = _rating;

@synthesize campaignId = _campaignId;
@synthesize answerText = _answerText;
@synthesize locale = _locale;
@synthesize userEmail = _userEmail;
@synthesize userId = _userId;
@synthesize userLocation = _userLocation;
@synthesize userNickname = _userNickname;
@synthesize productId = _productId;
@synthesize title = _title;
@synthesize categoryId = _categoryId;
@synthesize netPromoterComment = _netPromoterComment;
@synthesize reviewText = _reviewText;
@synthesize questionSummary = _questionSummary;
@synthesize questionDetails = _questionDetails;
@synthesize questionId = _questionId;
@synthesize sendEmailAlertWhenCommented = _sendEmailAlertWhenCommented;
@synthesize storyText = _storyText;
@synthesize reviewId = _reviewId;
@synthesize storyId = _storyId;
@synthesize commentText = _commentText;
@synthesize contentType = _contentType;
@synthesize contentId = _contentId;
@synthesize feedbackType = _feedbackType;
@synthesize vote = _vote;
@synthesize reasonText = _reasonText;

- (id)init{
    return [self initWithType:BVPostTypeReview];
}

- (id)initWithType:(BVPostType)type {
    self = [super init];
    if (self) {
        self.type = type;
        
        BVNetwork *network = [[BVNetwork alloc] initWithSender:self];
        self.network = network;

        
        // Standard params
        BVSettings *settings = [BVSettings instance];
        [self.network setUrlParameterWithName:@"ApiVersion" value:BV_API_VERSION];
        [self.network setUrlParameterWithName:@"PassKey" value:settings.passKey];
    }
    return self;
}


- (void)setDelegate:(id<BVDelegate>)delegate {
    self.network.delegate = delegate;
}

- (id<BVDelegate>)delegate {
    return self.network.delegate;
}

// Note: this is sort of a workaround... we want the requestURL to be read-only (which it appears as the client), but also the network needs to be able to set the requestURL
-(void)setRequestURL:(NSString *)requestURL{
    _requestURL = requestURL;
}

- (NSString *)getTypeString {
    switch (self.type) {
        case BVPostTypeAnswer:
            return @"submitanswer.json";
        case BVPostTypeReviewComment:
            return @"submitreviewcomment.json";
        case BVPostTypeStoryComment:
            return @"submitstorycomment.json";
        case BVPostTypeFeedback:
            return @"submitfeedback.json";
        case BVPostTypeQuestion:
            return @"submitquestion.json";
        case BVPostTypeReview:
            return @"submitreview.json";
        case BVPostTypeStory:
            return @"submitstory.json";
    }
}

- (NSString *)getActionString:(BVAction)action {
    switch (action) {
        case BVActionPreview:
            return @"preview";
        case BVActionSubmit:
            return @"submit";
    }
}

- (void)setAction:(BVAction)action {
    _action = action;
    [self.network setUrlParameterWithName:@"Action" value:[self getActionString:action]];
}


- (void)setAgreedToTermsAndConditions:(BOOL)agreedToTermsAndConditions{
    _agreedToTermsAndConditions = agreedToTermsAndConditions;
    [self.network setUrlParameterWithName:@"AgreedToTermsAndConditions" value:agreedToTermsAndConditions ? @"true": @"false"];
}

- (void)setSendEmailAlertWhenPublished:(BOOL)sendEmailAlertWhenPublished{
	_sendEmailAlertWhenPublished = sendEmailAlertWhenPublished;
	[self.network setUrlParameterWithName:@"SendEmailAlertWhenPublished" value:sendEmailAlertWhenPublished ? @"true": @"false"];
}

- (void)setSendEmailAlertWhenCommented:(BOOL)sendEmailAlertWhenCommented{
	_sendEmailAlertWhenCommented = sendEmailAlertWhenCommented;
	[self.network setUrlParameterWithName:@"SendEmailAlertWhenCommented" value:sendEmailAlertWhenCommented ? @"true": @"false"];
}

- (void)setIsRecommended:(BOOL)isRecommended{
	_isRecommended = isRecommended;
	[self.network setUrlParameterWithName:@"IsRecommended" value:isRecommended ? @"true": @"false"];
}

- (void)setIsUserAnonymous:(BOOL)isUserAnonymous{
	_isUserAnonymous = isUserAnonymous;
	[self.network setUrlParameterWithName:@"IsUserAnonymous" value:isUserAnonymous ? @"true": @"false"];
}

- (void)setNetPromoterScore:(int)netPromoterScore{
	_netPromoterScore = netPromoterScore;
	[self.network setUrlParameterWithName:@"NetPromoterScore" value:[NSString stringWithFormat:@"%d", netPromoterScore]];
}

- (void)setRating:(int)rating{
	_rating = rating;
	[self.network setUrlParameterWithName:@"Rating" value:[NSString stringWithFormat:@"%d", rating]];
}


- (void)setCampaignId:(NSString *)campaignId {
    _campaignId = campaignId;
    [self.network setUrlParameterWithName:@"CampaignId" value:campaignId];
}

- (void)setAnswerText:(NSString *)answerText {
    _answerText = answerText;
    [self.network setUrlParameterWithName:@"AnswerText" value:answerText];
}

- (void)setLocale:(NSString *)locale{
	_locale = locale;
	[self.network setUrlParameterWithName:@"Locale" value:locale];
}

- (void)setUserEmail:(NSString *)userEmail{
	_userEmail = userEmail;
	[self.network setUrlParameterWithName:@"UserEmail" value:userEmail];
}

- (void)setUserId:(NSString *)userId{
	_userId = userId;
	[self.network setUrlParameterWithName:@"UserId" value:userId];
}

- (void)setUserLocation:(NSString *)userLocation{
	_userLocation = userLocation;
	[self.network setUrlParameterWithName:@"UserLocation" value:userLocation];
}

- (void)setUserNickname:(NSString *)userNickname{
	_userNickname = userNickname;
	[self.network setUrlParameterWithName:@"UserNickname" value:userNickname];
}

- (void)setProductId:(NSString *)productId{
	_productId = productId;
	[self.network setUrlParameterWithName:@"ProductId" value:productId];
}

- (void)setTitle:(NSString *)title{
	_title = title;
	[self.network setUrlParameterWithName:@"Title" value:title];
}

- (void)setCategoryId:(NSString *)categoryId{
	_categoryId = categoryId;
	[self.network setUrlParameterWithName:@"CategoryId" value:categoryId];
}

- (void)setNetPromoterComment:(NSString *)netPromoterComment{
	_netPromoterComment = netPromoterComment;
	[self.network setUrlParameterWithName:@"NetPromoterComment" value:netPromoterComment];
}

- (void)setReviewText:(NSString *)reviewText{
	_reviewText = reviewText;
	[self.network setUrlParameterWithName:@"ReviewText" value:reviewText];
}

- (void)setQuestionSummary:(NSString *)questionSummary{
	_questionSummary = questionSummary;
	[self.network setUrlParameterWithName:@"QuestionSummary" value:questionSummary];
}

- (void)setQuestionDetails:(NSString *)questionDetails{
	_questionDetails = questionDetails;
	[self.network setUrlParameterWithName:@"QuestionDetails" value:questionDetails];
}

- (void)setQuestionId:(NSString *)questionId{
	_questionId = questionId;
	[self.network setUrlParameterWithName:@"QuestionId" value:questionId];
}

- (void)setStoryText:(NSString *)storyText{
	_storyText = storyText;
	[self.network setUrlParameterWithName:@"StoryText" value:storyText];
}

- (void)setReviewId:(NSString *)reviewId{
	_reviewId = reviewId;
	[self.network setUrlParameterWithName:@"ReviewId" value:reviewId];
}

- (void)setStoryId:(NSString *)storyId{
	_storyId = storyId;
	[self.network setUrlParameterWithName:@"StoryId" value:storyId];
}

- (void)setCommentText:(NSString *)commentText{
	_commentText = commentText;
	[self.network setUrlParameterWithName:@"CommentText" value:commentText];
}

- (void)setContentId:(NSString *)contentId{
    _contentId = contentId;
	[self.network setUrlParameterWithName:@"ContentId" value:contentId];
}

- (NSString *)getFeedbackContentTypeString:(BVFeedbackContentType)feedbackContentType {
    switch (feedbackContentType) {
        case BVFeedbackContentTypeAnswer:
            return @"answer";
        case BVFeedbackContentTypeQuestion:
            return @"question";
        case BVFeedbackContentTypeReview:
            return @"review";
        case BVFeedbackContentTypeReviewComment:
            return @"review_comment";
        case BVFeedbackContentTypeStory:
            return @"story";
        case BVFeedbackContentTypeStoryComment:
            return @"story_comment";
            
    }
}

- (void)setContentType:(BVFeedbackContentType)contentType{
    _contentType = contentType;
	[self.network setUrlParameterWithName:@"ContentType" value:[self getFeedbackContentTypeString:contentType]];
}

- (void)setReasonText:(NSString *)reasonText{
    _reasonText = reasonText;
	[self.network setUrlParameterWithName:@"ReasonText" value:reasonText];
}

- (NSString *)getFeedbackString:(BVFeedbackType)type{
    switch (type) {
        case BVFeedbackTypeHelpfulness:
            return @"helpfulness";
        case BVFeedbackTypeInappropriate:
            return @"inappropriate";
    }
}

- (void)setFeedbackType:(BVFeedbackType)feedbackType{
    _feedbackType = feedbackType;
    [self.network setUrlParameterWithName:@"FeedbackType" value:[self getFeedbackString:feedbackType]];
}

- (NSString *)getFeedbackVoteString:(BVFeedbackVoteType)type{
    switch (type) {
        case BVFeedbackVoteTypeNegative:
            return @"Negative";
        case BVFeedbackVoteTypePositive:
            return @"Positive";
    }
}

- (void)setVote:(BVFeedbackVoteType)vote{
    _vote = vote;
    [self.network setUrlParameterWithName:@"Vote" value:[self getFeedbackVoteString:vote]];
}


- (void)setContextDataValue:(NSString *)dimensionExternalId value:(NSString *)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"ContextDataValue_%@", dimensionExternalId]
                                    value:value];
}

- (void)setAdditionalField:(NSString *)dimensionExternalId value:(NSString *)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"AdditionalField_%@", dimensionExternalId]
                                    value:value];
}

- (void)setRatingForDimensionExternalId:(NSString *)dimensionExternalId value:(int)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"Rating_%@", dimensionExternalId]
                                    value:[NSString stringWithFormat:@"%d", value]];
}

- (void)addPhotoUrl:(NSString *)url withCaption:(NSString *)caption {
    [self.network addNthUrlParameterWithName:@"PhotoCaption" value:caption];
    [self.network addNthUrlParameterWithName:@"PhotoUrl" value:url];

}
- (void)addVideoUrl:(NSString *)url withCaption:(NSString *)caption {
    [self.network addNthUrlParameterWithName:@"VideoCaption" value:caption];
    [self.network addNthUrlParameterWithName:@"VideoUrl" value:url];
}

- (void)addProductRecommendationForIndex:(int)index withProductExternalId:(int)productExternalId {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"ProductRecommendationId_%d", index]
                                    value:[NSString stringWithFormat:@"%d", productExternalId]];
}

- (void)addTagForDimensionExternalId:(NSString *)dimensionExternalId value:(NSString *)value {
    [self.network addNthUrlParameterWithName:[NSString stringWithFormat:@"tag_%@", dimensionExternalId]
                                       value:value];
}

- (void)addTagIdForDimensionExternalId:(NSString *)dimensionExternalId value:(BOOL)value {
    [self.network addNthUrlParameterWithName:[NSString stringWithFormat:@"tagid_%@", dimensionExternalId]
                                       value:value ? @"true": @"false"];
}


- (void)addGenericParameterWithName:(NSString *)name value:(NSString *)value {
    [self.network setUrlParameterWithName:name value:value];
}

- (void) sendRequestWithDelegate:(id<BVDelegate>)delegate {
    [self setDelegate:delegate];
    [self send];
}

- (void) send {
    [self.network sendPostWithEndpoint:[self getTypeString]];
}


@end
