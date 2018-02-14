//
//  BVRelationalFilterOperatorValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVRELATIONALFILTEROPERATORVALUE_H
#define BVRELATIONALFILTEROPERATORVALUE_H

/*
 BVRelationalFilterOperator describes the operator used on filters added to
 request objects. For example: to search reviews that have ratings greater than
 3, you would use the BVRelationalFilterOperatorValueGreaterThanOrEqualTo
 operator.
 */
typedef NS_ENUM(NSInteger, BVRelationalFilterOperatorValue) {
  BVRelationalFilterOperatorValueGreaterThan,
  BVRelationalFilterOperatorValueGreaterThanOrEqualTo,
  BVRelationalFilterOperatorValueLessThan,
  BVRelationalFilterOperatorValueLessThanOrEqualTo,
  BVRelationalFilterOperatorValueEqualTo,
  BVRelationalFilterOperatorValueNotEqualTo,
};

#endif /* BVRELATIONALFILTEROPERATORVALUE_H */
