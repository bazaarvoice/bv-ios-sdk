//
//  BVAuthorContentType.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Types of Bazaarvoice content that can be included with a Profile.
 */
typedef NS_ENUM(NSInteger, BVAuthorContentType) {
    BVAuthorContentTypeReviews,
    BVAuthorContentTypeQuestions,
    BVAuthorContentTypeAnswers
};


@interface BVAuthorContentTypeUtil : NSObject

+(NSString*)toString:(BVAuthorContentType)type;

@end
