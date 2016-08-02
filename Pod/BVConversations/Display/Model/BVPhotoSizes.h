//
//  PhotoSizes.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Contains the thumbnail URL and normal-sized URL of a `BVPhoto`.
 */
@interface BVPhotoSizes : NSObject

@property NSString* _Nullable thumbnailUrl;
@property NSString* _Nullable normalUrl;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
