//
//  PDPContentType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "PDPContentType.h"

@implementation PDPContentTypeUtil

+ (NSString *)toString:(PDPContentType)type {
  switch (type) {
  case PDPContentTypeReviews:
    return @"Reviews";
  case PDPContentTypeAnswers:
    return @"Answers";
  case PDPContentTypeQuestions:
    return @"Questions";
  }
}

@end
