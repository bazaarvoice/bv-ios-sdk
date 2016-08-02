//
//  DistributionElement.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVDistributionValue.h"

/*
 A single tag distribition.
 */
@interface BVDistributionElement : NSObject

@property NSString* _Nonnull label;
@property NSString* _Nonnull identifier;
@property NSArray<BVDistributionValue*>* _Nonnull values;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
