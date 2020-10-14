//
//  BVSyndicationSource.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 If a review is syndicated, a BVSyndicationSource will contain the details of
 where the syndication is coming from is displayed. NOTE: The API key must be
 configured to show syndicated content.
 */
@interface BVSyndicationSource : NSObject

@property(nullable, readonly) NSString *logoImageUrl;
@property(nullable, readonly) NSString *contentLink;
@property(nullable, readonly) NSString *name;
@property(nullable, readonly) NSString *clientId;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
