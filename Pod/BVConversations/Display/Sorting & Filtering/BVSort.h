//
//  Sorts.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSortOptionProducts.h"

/*
 Sort ordering can be `ascending` or `descending`.
 */
typedef NS_ENUM(NSInteger, BVSortOrder) {
    BVSortOrderAscending,
    BVSortOrderDescending
};

@interface BVSort : NSObject

-(id _Nonnull)initWithOption:(BVSortOptionProducts)option order:(BVSortOrder)order;
-(id _Nonnull)initWithOptionString:(NSString* _Nonnull)optionString order:(BVSortOrder)order;
-(NSString* _Nonnull)toString;

@end
