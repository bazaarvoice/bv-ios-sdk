//
//  BVAdInfo.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVCommon.h"

@interface BVAdInfo : NSObject

@property unsigned long long adLoadId;
@property NSDictionary* customTargeting;
@property NSString* adUnitId;
@property BVAdType adType;


-(id)initWithAdUnitId:(NSString*)adUnitId adType:(BVAdType)adType;
-(NSString*)getFormattedAdType;

@end
