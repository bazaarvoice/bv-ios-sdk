//
//  Sorts.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSortOptionProducts.h"
#import <Foundation/Foundation.h>

/*
 Sort ordering can be `ascending` or `descending`.
 */
typedef NS_ENUM(NSInteger, BVSortOrder) {
  BVSortOrderAscending,
  BVSortOrderDescending
};

@interface BVSort : NSObject

- (nonnull id)initWithOption:(BVSortOptionProducts)option
                       order:(BVSortOrder)order;
- (nonnull id)initWithOptionString:(nonnull NSString *)optionString
                             order:(BVSortOrder)order;
- (nonnull NSString *)toString;

@end
