//
//  Badge.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVBadgeType.h"

/*
 Badge to attribute a piece of content with certain characteristics:
     * user received a free sample
     * user is a verified purchaser
     * user is affiliated with a certain company
 See a full tutorial on badging here: https://developer.bazaarvoice.com/apis/conversations/tutorials/Badges_Display
 */
@interface BVBadge : NSObject

@property BVBadgeType badgeType;
@property NSString* _Nullable identifier;
@property NSString* _Nullable contentType;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
