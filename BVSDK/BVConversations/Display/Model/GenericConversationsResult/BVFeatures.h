//
//  BVFeatures.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 


#import "BVGenericConversationsResult.h"
#import "BVFeature.h"


@interface BVFeatures : BVGenericConversationsResult

@property(nullable) NSString *productId;
@property(nullable) NSString *language;
@property(nonnull) NSArray<BVFeature *> *features;

@end
