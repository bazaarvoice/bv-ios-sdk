//
//  FilterOperator.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 BVFilterOperator describes the operator used on filters added to request
 objects. For example: to search reviews that have ratings greater than 3, you
 would use the BVFilterOperatorGreaterThanOrEqualTo operator.
 */
typedef NS_ENUM(NSInteger, BVFilterOperator) {
  BVFilterOperatorGreaterThan,
  BVFilterOperatorGreaterThanOrEqualTo,
  BVFilterOperatorLessThan,
  BVFilterOperatorLessThanOrEqualTo,
  BVFilterOperatorEqualTo,
  BVFilterOperatorNotEqualTo,
};

@interface BVFilterOperatorUtil : NSObject

+ (nonnull NSString *)toString:(BVFilterOperator)filterOperator;

@end
