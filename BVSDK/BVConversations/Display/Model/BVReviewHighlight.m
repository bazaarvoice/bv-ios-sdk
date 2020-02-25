//
//  BVReviewHighlight.m
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlight.h"
#import "BVNullHelper.h"


@implementation BVReviewHighlight

- (id)initWithTitle:(NSString *)title content:(id)content {
    
    if ((self = [super init])) {
        
        self.title = title;
        
        if (!content || ![content isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSDictionary *apiObject = (NSDictionary *)content;
        
        SET_IF_NOT_NULL(self.mentionsCount, apiObject[@"mentionsCount"])
        SET_IF_NOT_NULL(self.presenceCount, apiObject[@"presenceCount"])
        
        NSArray<NSDictionary *> *bestExamplesDictionary = (NSArray<NSDictionary *> *)[apiObject objectForKey:@"bestExamples"];
        
        NSMutableArray *bestExamplesArrayBuilder = [NSMutableArray array];
        
        for (NSDictionary *bestExample in bestExamplesDictionary) {
            BVReviewHighligtsReview *review = [[BVReviewHighligtsReview alloc] initWithApiResponse:bestExample];
            
            [bestExamplesArrayBuilder addObject:review];
        }
        
        if (bestExamplesArrayBuilder.count == 0) {
            return nil;
        }
        
        self.bestExamples = bestExamplesArrayBuilder;
        

    }
    
    
    return self;
}

@end
