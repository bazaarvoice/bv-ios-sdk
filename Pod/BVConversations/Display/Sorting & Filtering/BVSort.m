//
//  Sorts.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSort.h"

@interface BVSort()

@property NSString* _Nonnull option;
@property BVSortOrder order;

@end

@implementation BVSort

-(id _Nonnull)initWithOption:(BVSortOptionProducts)option order:(BVSortOrder)order {
    self = [super init];
    if(self){
        self.option = [BVSortOptionProductsUtil toString:option];
        self.order = order;
    }
    return self;
}

-(id _Nonnull)initWithOptionString:(NSString* _Nonnull)optionString order:(BVSortOrder)order {
    self = [super init];
    if(self){
        self.option = optionString;
        self.order = order;
    }
    return self;
}

-(NSString* _Nonnull)toString {
    return [NSString stringWithFormat:@"%@:%@", self.option, [self orderingString:self.order]];
}

-(NSString* _Nonnull)orderingString:(BVSortOrder)order {
    return self.order == BVSortOrderAscending ? @"asc" : @"desc";
}

@end
