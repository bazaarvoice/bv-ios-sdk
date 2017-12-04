//
//  BVBulkRatingsFilterType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsFilterType.h"

@implementation BVBulkRatingsFilterTypeUtil

+ (nonnull NSString *)toString:(BVBulkRatingsFilterType)filterOperator {
  switch (filterOperator) {
  case BVBulkRatingsFilterTypeContentLocale:
    return @"ContentLocale";
  }
}

@end
