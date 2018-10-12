//
//  Sorts.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSort.h"

@interface BVSort ()

@property(nonnull) NSString *sortOption;
@property(nonnull) NSString *sortOrder;

@end

@implementation BVSort

- (nonnull id)initWithSortOption:(nonnull id<BVSortOptionProtocol>)sortOption
                       sortOrder:(nonnull id<BVSortOrderProtocol>)sortOrder {
  if ((self = [super init])) {
    self.sortOption = [sortOption toSortOptionParameterString];
    self.sortOrder = [sortOrder toSortOrderParameterString];
  }
  return self;
}

- (nonnull id)initWithSortOptionString:(nonnull NSString *)sortOptionString
                             sortOrder:
                                 (nonnull id<BVSortOrderProtocol>)sortOrder {
  if ((self = [super init])) {
    self.sortOption = sortOptionString;
    self.sortOrder = [sortOrder toSortOrderParameterString];
  }
  return self;
}

- (nonnull NSString *)toParameterString {
  return [NSString stringWithFormat:@"%@:%@", self.sortOption, self.sortOrder];
}

@end
