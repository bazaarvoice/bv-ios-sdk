//
//  Filters.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilterOperator.h"
#import "BVProductFilterType.h"
#import <Foundation/Foundation.h>

/// Internal class - used only within BVSDK
@interface BVFilter : NSObject

- (nonnull id)initWithType:(BVProductFilterType)type
            filterOperator:(BVFilterOperator)filterOperator
                    values:(nonnull NSArray<NSString *> *)values;
- (nonnull id)initWithType:(BVProductFilterType)type
            filterOperator:(BVFilterOperator)filterOperator
                     value:(nonnull NSString *)value;
- (nonnull id)initWithString:(nonnull NSString *)str
              filterOperator:(BVFilterOperator)filterOperator
                      values:(nonnull NSArray<NSString *> *)values;
- (nonnull NSString *)toParameterString;

@end
