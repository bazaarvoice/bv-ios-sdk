//
//  PDPContentType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Types of Bazaarvoice content.
 */
typedef NS_ENUM(NSInteger, PDPContentType) {
  PDPContentTypeReviews,
  PDPContentTypeQuestions,
  PDPContentTypeAnswers
};

@interface PDPContentTypeUtil : NSObject

+ (NSString *)toString:(PDPContentType)type;

@end
