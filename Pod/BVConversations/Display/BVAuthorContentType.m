//
//  BVAuthorContentType.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorContentType.h"

@implementation BVAuthorContentTypeUtil

+(NSString*)toString:(BVAuthorContentType)type {
    switch (type) {
        case BVAuthorContentTypeReviews:
            return @"Reviews";
        case BVAuthorContentTypeAnswers:
            return @"Answers";
        case BVAuthorContentTypeQuestions:
            return @"Questions";
    }
}

@end
