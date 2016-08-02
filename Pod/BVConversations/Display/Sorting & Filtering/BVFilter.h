//
//  Filters.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVProductFilterType.h"
#import "BVFilterOperator.h"

/// Internal class - used only within BVSDK
@interface BVFilter : NSObject

-(id _Nonnull)initWithType:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString*>* _Nonnull)values;
-(id _Nonnull)initWithType:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString* _Nonnull)value;
-(id _Nonnull)initWithString:(NSString* _Nonnull)str filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString*>* _Nonnull)values;
-(NSString* _Nonnull)toParameterString;

@end
