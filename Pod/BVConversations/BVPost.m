//
//  BVPost.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import "BVPost.h"
#import "BVSettings.h"
#import "BVNetwork.h"
#import "BVConversationsAnalyticsHelper.h"

@interface BVPost()
@property BVNetwork *network;
@end

@implementation BVPost

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
        BVSDKManager *sdkManager = [BVSDKManager sharedManager];
        
        // check that `apiKeyConversations` is valid. Will fail only in debug mode.
        NSAssert(sdkManager.apiKeyConversations != nil && ![sdkManager.apiKeyConversations isEqualToString:@""], @"You must supply apiKeyConversations in the BVSDKManager before using the Bazaarvoice SDK.");
        
        [self.network setUrlParameterWithName:@"ApiVersion" value:BV_API_VERSION];
        [self.network setUrlParameterWithName:@"PassKey" value:sdkManager.apiKeyConversations];
    }
    return self;
}


- (void)setDelegate:(id<BVDelegate>)delegate {
    self.network.delegate = delegate;
}

- (id<BVDelegate>)delegate {
    return self.network.delegate;
}

-(void)setRequestURL:(NSString *)requestURL{
    _requestURL = requestURL;
}

- (void)setAction:(BVAction)action {
    _action = action;
    [self.network setUrlParameterWithName:@"Action" value:[self getActionString:action]];
}

- (void)setAgreedToTermsAndConditions:(BOOL)agreedToTermsAndConditions{
    _agreedToTermsAndConditions = agreedToTermsAndConditions;
    [self.network setUrlParameterWithName:@"AgreedToTermsAndConditions" value:agreedToTermsAndConditions ? @"true": @"false"];
}

- (void)setCampaignId:(NSString *)campaignId {
    _campaignId = campaignId;
    [self.network setUrlParameterWithName:@"CampaignId" value:campaignId];
}

- (void)setLocale:(NSString *)locale{
	_locale = locale;
	[self.network setUrlParameterWithName:@"Locale" value:locale];
}

- (void)setSendEmailAlertWhenPublished:(BOOL)sendEmailAlertWhenPublished{
	_sendEmailAlertWhenPublished = sendEmailAlertWhenPublished;
	[self.network setUrlParameterWithName:@"SendEmailAlertWhenPublished" value:sendEmailAlertWhenPublished ? @"true": @"false"];
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

- (void)setContextDataValue:(NSString *)dimensionExternalId value:(NSString *)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"ContextDataValue_%@", dimensionExternalId]
                                    value:value];
}

- (void)addPhotoUrl:(NSString *)url withCaption:(NSString *)caption {
    [self.network addNthUrlParameterWithName:@"PhotoCaption" value:caption];
    [self.network addNthUrlParameterWithName:@"PhotoUrl" value:url];
    
}

- (void)addProductRecommendationForIndex:(int)index withProductExternalId:(int)productExternalId {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"ProductRecommendationId_%d", index]
                                    value:[NSString stringWithFormat:@"%d", productExternalId]];
}

- (void)addVideoUrl:(NSString *)url withCaption:(NSString *)caption {
    [self.network addNthUrlParameterWithName:@"VideoCaption" value:caption];
    [self.network addNthUrlParameterWithName:@"VideoUrl" value:url];
}

//  Used by Review, Question, Answer, Story 

- (void)setAdditionalField:(NSString *)dimensionExternalId value:(NSString *)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"AdditionalField_%@", dimensionExternalId]
                                    value:value];
}

//  Used by Review, Question, Story 

- (void)setProductId:(NSString *)productId{
	_productId = productId;
	[self.network setUrlParameterWithName:@"ProductId" value:productId];
}

- (void)addTagForDimensionExternalId:(NSString *)dimensionExternalId value:(NSString *)value {
    [self.network addNthUrlParameterWithName:[NSString stringWithFormat:@"tag_%@", dimensionExternalId]
                                       value:value];
}

- (void)addTagIdForDimensionExternalId:(NSString *)dimensionExternalId value:(BOOL)value {
    [self.network addNthUrlParameterWithName:[NSString stringWithFormat:@"tagid_%@", dimensionExternalId]
                                       value:value ? @"true": @"false"];
}

//  Used by Review, Story, Comment 

- (void)setTitle:(NSString *)title{
	_title = title;
	[self.network setUrlParameterWithName:@"Title" value:title];
}

//  Used by Question, Story 

- (void)setCategoryId:(NSString *)categoryId{
	_categoryId = categoryId;
	[self.network setUrlParameterWithName:@"CategoryId" value:categoryId];
}

//  Used by Review 

- (void)setIsRecommended:(BOOL)isRecommended{
	_isRecommended = isRecommended;
	[self.network setUrlParameterWithName:@"IsRecommended" value:isRecommended ? @"true": @"false"];
}

- (void)setNetPromoterComment:(NSString *)netPromoterComment{
	_netPromoterComment = netPromoterComment;
	[self.network setUrlParameterWithName:@"NetPromoterComment" value:netPromoterComment];
}

- (void)setNetPromoterScore:(int)netPromoterScore{
	_netPromoterScore = netPromoterScore;
	[self.network setUrlParameterWithName:@"NetPromoterScore" value:[NSString stringWithFormat:@"%d", netPromoterScore]];
}

- (void)setRating:(int)rating{
	_rating = rating;
	[self.network setUrlParameterWithName:@"Rating" value:[NSString stringWithFormat:@"%d", rating]];
}

- (void)setReviewText:(NSString *)reviewText{
	_reviewText = reviewText;
	[self.network setUrlParameterWithName:@"ReviewText" value:reviewText];
}

- (void)setRatingForDimensionExternalId:(NSString *)dimensionExternalId value:(int)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"Rating_%@", dimensionExternalId]
                                    value:[NSString stringWithFormat:@"%d", value]];
}

//  Used by Question 

- (void)setIsUserAnonymous:(BOOL)isUserAnonymous{
	_isUserAnonymous = isUserAnonymous;
	[self.network setUrlParameterWithName:@"IsUserAnonymous" value:isUserAnonymous ? @"true": @"false"];
}

- (void)setQuestionSummary:(NSString *)questionSummary{
	_questionSummary = questionSummary;
	[self.network setUrlParameterWithName:@"QuestionSummary" value:questionSummary];
}

- (void)setQuestionDetails:(NSString *)questionDetails{
	_questionDetails = questionDetails;
	[self.network setUrlParameterWithName:@"QuestionDetails" value:questionDetails];
}

//  Used by Answer 
- (void)setAnswerText:(NSString *)answerText {
    _answerText = answerText;
    [self.network setUrlParameterWithName:@"AnswerText" value:answerText];
}

- (void)setQuestionId:(NSString *)questionId{
	_questionId = questionId;
	[self.network setUrlParameterWithName:@"QuestionId" value:questionId];
}

//  Used by Story 

- (void)setSendEmailAlertWhenCommented:(BOOL)sendEmailAlertWhenCommented{
	_sendEmailAlertWhenCommented = sendEmailAlertWhenCommented;
	[self.network setUrlParameterWithName:@"SendEmailAlertWhenCommented" value:sendEmailAlertWhenCommented ? @"true": @"false"];
}

- (void)setStoryText:(NSString *)storyText{
	_storyText = storyText;
	[self.network setUrlParameterWithName:@"StoryText" value:storyText];
}

//  Used by Comment 

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

// Hosted Authentication

- (void)setHostedAuthEmail:(NSString *)email{
    _hostedAuthEmail = email;
    [self.network setUrlParameterWithName:@"HostedAuthentication_AuthenticationEmail" value:_hostedAuthEmail];
}

- (void)setHostedAuthCallbackUrl:(NSString *)url{
    _hostedAuthCallbackUrl = url;
    [self.network setUrlParameterWithName:@"HostedAuthentication_CallbackURL" value:_hostedAuthCallbackUrl];
}

- (void)setAuthenticatedUser:(NSString *)authenticatedUser{
    _authenticatedUser = authenticatedUser;
    [self.network setUrlParameterWithName:@"User" value:_authenticatedUser];
}

//  Used by Feedback 

- (void)setContentId:(NSString *)contentId{
    _contentId = contentId;
	[self.network setUrlParameterWithName:@"ContentId" value:contentId];
}

- (void)setContentType:(BVFeedbackContentType)contentType{
    _contentType = contentType;
	[self.network setUrlParameterWithName:@"ContentType" value:[self getFeedbackContentTypeString:contentType]];
}

- (void)setFeedbackType:(BVFeedbackType)feedbackType{
    _feedbackType = feedbackType;
    [self.network setUrlParameterWithName:@"FeedbackType" value:[self getFeedbackString:feedbackType]];
}

- (void)setReasonText:(NSString *)reasonText{
    _reasonText = reasonText;
	[self.network setUrlParameterWithName:@"ReasonText" value:reasonText];
}

- (void)setVote:(BVFeedbackVoteType)vote{
    _vote = vote;
    [self.network setUrlParameterWithName:@"Vote" value:[self getFeedbackVoteString:vote]];
}

- (void)setFingerPrint:(NSString *)fp{
    
    _fingerPrint = fp;
    [self.network setUrlParameterWithName:@"fp" value:fp];
    
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
    
    // send a used feature event for the POST
    [[BVConversationsAnalyticsHelper instance] queueAnalyticsEventForFeatureUsed:self];

}

#pragma mark - helper methods

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

//  Used by All Types of BVPost Requests

- (NSString *)getActionString:(BVAction)action {
    switch (action) {
        case BVActionPreview:
            return @"preview";
        case BVActionSubmit:
            return @"submit";
    }
}

// Used by Feedback

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

- (NSString *)getFeedbackVoteString:(BVFeedbackVoteType)type{
    switch (type) {
        case BVFeedbackVoteTypeNegative:
            return @"Negative";
        case BVFeedbackVoteTypePositive:
            return @"Positive";
    }
}

- (NSString *)getFeedbackString:(BVFeedbackType)type{
    switch (type) {
        case BVFeedbackTypeHelpfulness:
            return @"helpfulness";
        case BVFeedbackTypeInappropriate:
            return @"inappropriate";
    }
}


@end
