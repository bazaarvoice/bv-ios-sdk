//
//  BVSyndicationSource.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 If a review is syndicated, a BVSyndicationSource will contain the details of where the syndication is coming from is displayed. NOTE: The API key must be configured to show syndicated content.
 */
@interface BVSyndicationSource : NSObject

@property (readonly) NSString * _Nullable logoImageUrl;
@property (readonly) NSString * _Nullable contentLink;
@property (readonly) NSString * _Nullable name;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
