//
//  FilterOperator.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilterOperator.h"

@implementation BVFilterOperatorUtil

+ (nonnull NSString *)toString:(BVFilterOperator)filterOperator {

  switch (filterOperator) {
  case BVFilterOperatorGreaterThan:
    return @"gt";
  case BVFilterOperatorGreaterThanOrEqualTo:
    return @"gte";
  case BVFilterOperatorLessThan:
    return @"lt";
  case BVFilterOperatorLessThanOrEqualTo:
    return @"lte";
  case BVFilterOperatorEqualTo:
    return @"eq";
  case BVFilterOperatorNotEqualTo:
    return @"neq";
  }
}

@end
