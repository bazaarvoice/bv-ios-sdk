//
//  DistributionValue.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The value of a tag distribution -- see BVDistributionElement.h
 */
@interface BVDistributionValue : NSObject

@property NSString* _Nonnull value;
@property NSNumber* _Nonnull count;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
