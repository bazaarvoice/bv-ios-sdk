//
//  ReviewsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewsRequest.h"
#import "BVFilter.h"
#import "BVSort.h"
#import "BVCommaUtil.h"
#import "BVLogger.h"
#import "PDPInclude.h"
#import "BVSDKManager.h"
#import "BVSDKConfiguration.h"

@interface BVStoreReviewsRequest()

@property NSMutableArray<NSNumber*>* _Nonnull storeContentTypeStatistics;
@property NSMutableArray<BVSort*>* _Nonnull reviewSorts;

@end

@implementation BVStoreReviewsRequest

- (nonnull instancetype)initWithStoreId:(NSString * _Nonnull)storeId limit:(int)limit offset:(int)offset {
    return self = [super initWithID:storeId limit:limit offset:offset];
}
    
- (nonnull instancetype)includeStatistics:(BVStoreIncludeContentType)contentType {
    [self.storeContentTypeStatistics addObject:@(contentType)];
    return self;
}


-(NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(NSNumber* stat in statistics) {
        [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

- (NSString * _Nonnull)getPassKey{
    return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}

-(NSString*)storeId {
    return self.ID;
}

-(id<BVResponse>)createResponse:(NSDictionary *)raw {
    return [[BVStoreReviewsResponse alloc]initWithApiResponse:raw];
}

@end
