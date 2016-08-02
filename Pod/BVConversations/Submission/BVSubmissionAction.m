//
//  BVSubmissionAction.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionAction.h"

@implementation BVSubmissionActionUtil

+(NSString* _Nonnull)toString:(BVSubmissionAction)action {
    
    switch (action) {
            
        case BVSubmissionActionSubmit: return @"Submit";
        case BVSubmissionActionPreview: return @"Preview";
            
    }
    
}

@end
