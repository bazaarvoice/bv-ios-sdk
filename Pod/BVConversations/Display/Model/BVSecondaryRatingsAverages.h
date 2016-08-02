//
//  SecondaryRatingsAverages.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVSecondaryRatingsAverages : NSDictionary

+(BVSecondaryRatingsAverages* _Nullable)createWithDictionary:(id _Nullable)apiResponse;

@end
