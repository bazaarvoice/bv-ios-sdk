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

- (nonnull id)initWithCustomOrderSortOption:(nonnull id<BVSortOptionProtocol>)customOrderSortOption
                            customSortOrder:(nonnull id<BVCustomSortOrderProtocol>)customSortOrder{
    if ((self = [super init])) {
      self.sortOption = [customOrderSortOption toSortOptionParameterString];
      self.sortOrder = [customSortOrder toCustomSortOrderParameterString];
    }
    return self;
}

- (nonnull id)initWithSortOption:(nonnull id<BVSortOptionProtocol>)sortOption
                       sortType:(nonnull id<BVSortTypeProtocol>)sortType {
  if ((self = [super init])) {
    self.sortOption = [sortOption toSortOptionParameterString];
    self.sortOrder = [sortType toSortTypeParameterString];
  }
  return self;
}


- (nonnull NSString *)toParameterString {
  return [NSString stringWithFormat:@"%@:%@", self.sortOption, self.sortOrder];
}

@end
