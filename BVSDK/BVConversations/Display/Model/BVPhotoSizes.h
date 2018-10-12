//
//  PhotoSizes.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Contains the thumbnail URL and normal-sized URL of a `BVPhoto`.
 */
@interface BVPhotoSizes : NSObject

@property(nullable) NSString *thumbnailUrl;
@property(nullable) NSString *normalUrl;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
