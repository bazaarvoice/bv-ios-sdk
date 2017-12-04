//
//  Sorts.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSort.h"

@interface BVSort ()

@property(nonnull) NSString *option;
@property BVSortOrder order;

@end

@implementation BVSort

- (nonnull id)initWithOption:(BVSortOptionProducts)option
                       order:(BVSortOrder)order {
  self = [super init];
  if (self) {
    self.option = [BVSortOptionProductsUtil toString:option];
    self.order = order;
  }
  return self;
}

- (nonnull id)initWithOptionString:(nonnull NSString *)optionString
                             order:(BVSortOrder)order {
  self = [super init];
  if (self) {
    self.option = optionString;
    self.order = order;
  }
  return self;
}

- (nonnull NSString *)toString {
  return [NSString
      stringWithFormat:@"%@:%@", self.option, [self orderingString:self.order]];
}

- (nonnull NSString *)orderingString:(BVSortOrder)order {
  return self.order == BVSortOrderAscending ? @"asc" : @"desc";
}

@end
