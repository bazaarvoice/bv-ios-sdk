//
//  BVAuthorResponse.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVResponse.h"
#import "BVAuthor.h"

@interface BVAuthorResponse : NSObject<BVResponse>

@property NSNumber* _Nullable offset;
@property NSString* _Nullable locale;
@property NSArray<BVAuthor*>* _Nonnull results;
@property NSNumber* _Nullable totalResults;
@property NSNumber* _Nullable limit;

@end
