//
//  Badge.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBadgeType.h"
#import <Foundation/Foundation.h>

/*
 Badge to attribute a piece of content with certain characteristics:
     * user received a free sample
     * user is a verified purchaser
     * user is affiliated with a certain company
 See a full tutorial on badging here:
 https://developer.bazaarvoice.com/apis/conversations/tutorials/Badges_Display
 */
@interface BVBadge : NSObject

/// The BadgeType lists the badge category. Values include "Merit", "Custom",
/// "Affiliation", and "Rank". These are codes internal to Bazaarvoice.
@property BVBadgeType badgeType;
/// The badge Id can be used to obtain the related ContextDataValues that can
/// also be returned in the API repsonse when configured. ContextDataValues can
/// contain additional metadata such as a label to be displayed rather than an
/// icon or ToolTip copy.
@property(nullable) NSString *identifier;
/// The badge ContentType indicates the specific item the badge is meant for.
/// Typical values are 'REVIEWS', 'QUESTIONS', or 'ANSWERS'.
@property(nullable) NSString *contentType;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
