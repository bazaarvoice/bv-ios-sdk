//
//  Photo.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVPhotoSizes.h"

/*
 A photo attached to a review, question, or answer. Check the `sizes` property for thumbnail URLs and normal URLs.
 */
@interface BVPhoto : NSObject

@property NSString* _Nullable caption;
@property BVPhotoSizes* _Nullable sizes;
@property NSString* _Nullable identifier;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
