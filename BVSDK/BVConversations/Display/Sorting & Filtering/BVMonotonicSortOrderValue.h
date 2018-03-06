//
//  BVMonotonicSortOrderValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVMONOTONICSORTORDERVALUE_H
#define BVMONOTONICSORTORDERVALUE_H

/*
 Sort ordering can be `ascending` or `descending`.
 */
typedef NS_ENUM(NSInteger, BVMonotonicSortOrderValue) {
  BVMonotonicSortOrderValueAscending,
  BVMonotonicSortOrderValueDescending
};

#endif /* BVMONOTONICSORTORDERVALUE_H */
