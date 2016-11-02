//
//  RatingDistribution.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVRatingDistribution.h"

@implementation BVRatingDistribution

-(id _Nullable)initWithApiResponse:(id _Nullable)apiRepsonse {
    
    self = [super init];
    if(self){
        if (apiRepsonse == nil || ![apiRepsonse isKindOfClass:[NSArray class]]) {
            return nil;
        }
        
        NSArray<NSDictionary*>* apiObject = apiRepsonse;
        for(NSDictionary* value in apiObject) {
            NSNumber* count = value[@"Count"];
            NSNumber* valueNum = value[@"RatingValue"];
            
            int valueInt = [valueNum intValue];
            switch (valueInt) {
                case 1:
                    self.oneStarCount = count;
                    break;
                case 2:
                    self.twoStarCount = count;
                    break;
                case 3:
                    self.threeStarCount = count;
                    break;
                case 4:
                    self.fourStarCount = count;
                    break;
                default:
                    self.fiveStarCount = count;
                    break;
            }
        }
    }
    return self;
    
}

@end
