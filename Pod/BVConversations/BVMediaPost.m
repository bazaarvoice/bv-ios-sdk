//
//  BVMediaPost.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import "BVMediaPost.h"
#import "BVNetwork.h"
#import "BVSettings.h"
#import "BVConversationsAnalyticsHelper.h"

@interface BVMediaPost() {
    BVVideoFormatType _videoFormat;
}
@property BVNetwork *network;
@end


@implementation BVMediaPost

- (id)init{
    return [self initWithType:BVMediaPostTypePhoto];
}

- (id)initWithType:(BVMediaPostType)type {
    self = [super init];
    if (self) {
        self.type = type;
        
        BVNetwork *network = [[BVNetwork alloc] initWithSender:self];
        self.network = network;
        
        // Standard params
        BVSDKManager *sdkManager = [BVSDKManager sharedManager];
        
        // Make sure you set up your own passKey and clientId!
        assert(sdkManager.apiKeyConversations != nil);
        assert(sdkManager.clientId != nil);
        
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

- (void)setContentType:(BVMediaPostContentType)contentType {
    _contentType = contentType;
    [self.network setUrlParameterWithName:@"ContentType" value:[self getContentTypeString]];
}

- (void)setLocale:(NSString *)locale{
	_locale = locale;
	[self.network setUrlParameterWithName:@"Locale" value:locale];
}

- (void)setUserId:(NSString *)userId{
	_userId = userId;
	[self.network setUrlParameterWithName:@"UserId" value:userId];
}

- (void)setPhoto:(UIImage *)photo{
	_photo = photo;
	[self.network setUrlParameterWithName:@"photo" value:photo];
}

- (void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl = photoUrl;
	[self.network setUrlParameterWithName:@"photoUrl" value:photoUrl];
}

- (void)setVideo:(NSData *)video withFormat:(BVVideoFormatType)format {
    _videoFormat = format;
    [self.network setUrlParameterWithName:@"video" value:video];
}


- (void)addGenericParameterWithName:(NSString *)name value:(NSString *)value {
    [self.network setUrlParameterWithName:name value:value];
}

- (void) sendRequestWithDelegate:(id<BVDelegate>)delegate {
    [self setDelegate:delegate];
    [self send];
}

- (void)send {
    if(self.photoUrl){
        [self.network sendPostWithEndpoint:[self getTypeString]];
    } else {
        [self.network sendMultipartPostWithEndpoint:[self getTypeString]];        
    }
    
    // send a used feature event for the POST
    [[BVConversationsAnalyticsHelper instance] queueAnalyticsEventForMediaPost:self];


}

#pragma mark - helper methods

- (NSString *)getTypeString {
    switch (self.type) {
        case BVMediaPostTypePhoto:
            return @"uploadphoto.json";
        case BVMediaPostTypeVideo:
            return @"uploadvideo.json";
    }
}

- (NSString *)getContentTypeString {
    switch (self.contentType) {
        case BVMediaPostContentTypeAnswer:
            return @"answer";
        case BVMediaPostContentTypeQuestion:
            return @"question";
        case BVMediaPostContentTypeReview:
            return @"review";
        case BVMediaPostContentTypeReviewComment:
            return @"review_comment";
        case BVMediaPostContentTypeStory:
            return @"story";
        case BVMediaPostContentTypeStoryComment:
            return @"story_comment";
    }
}

- (NSString *)getVideoExtensionString {
    switch(_videoFormat){
        case BVVideoFormatType3G2:
            return @"3g2";
        case BVVideoFormatType3GP:
            return @"3gp";
        case BVVideoFormatTypeASF:
            return @"asf";
        case BVVideoFormatTypeDV:
            return @"dv";
        case BVVideoFormatTypeF4V:
            return @"f4v";
        case BVVideoFormatTypeFLV:
            return @"flv";
        case BVVideoFormatTypeMOV:
            return @"mov";
        case BVVideoFormatTypeMP4:
            return @"mp4";
        case BVVideoFormatTypeMPEG:
            return @"mpg";
        case BVVideoFormatTypeQT:
            return @"qt";
        case BVVideoFormatTypeWMV:
            return @"wmv";
    }
    
}

@end
