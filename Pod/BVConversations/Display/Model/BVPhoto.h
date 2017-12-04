//
//  Photo.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVPhotoSizes.h"
#import <Foundation/Foundation.h>

/*
 A photo attached to a review, question, or answer. Check the `sizes` property
 for thumbnail URLs and normal URLs.
 */
@interface BVPhoto : NSObject

@property(nullable) NSString *caption;
@property(nullable) BVPhotoSizes *sizes;
@property(nullable) NSString *identifier;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
