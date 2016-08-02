//
//  Filters.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilter.h"
#import "BVCommaUtil.h"

@interface BVFilter()

@property NSString* _Nonnull type;
@property BVFilterOperator filterOperator;
@property NSArray<NSString*>* _Nonnull values;

@end

@implementation BVFilter

-(id _Nonnull)initWithType:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString*>* _Nonnull)values {
    self = [super init];
    if(self){
        self.type = [BVProductFilterTypeUtil toString:type];
        self.filterOperator = filterOperator;
        self.values = [BVCommaUtil escapeMultiple:values];
    }
    return self;
}

-(id _Nonnull)initWithType:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString* _Nonnull)value {
    self = [super init];
    if(self){
        self.type = [BVProductFilterTypeUtil toString:type];
        self.filterOperator = filterOperator;
        self.values = [BVCommaUtil escapeMultiple:@[value]];
    }
    return self;
}

-(id _Nonnull)initWithString:(NSString* _Nonnull)str filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString*>* _Nonnull)values {
    self = [super init];
    if(self){
        self.type = str;
        self.filterOperator = filterOperator;
        self.values = [BVCommaUtil escapeMultiple:values];
    }
    return self;
}

-(NSString*)toParameterString {
    NSString* start = self.type;
    NSString* middle = [BVFilterOperatorUtil toString:self.filterOperator];
    NSArray<NSString*>* sortedArray = [self.values sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString* end = [sortedArray componentsJoinedByString:@","];
    
    return [NSString stringWithFormat:@"%@:%@:%@", start, middle, end];
}

@end
