//
//  BVAuthorInclude.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVAuthorContentType.h"

@interface BVAuthorInclude : NSObject

@property BVAuthorContentType type;
@property NSNumber* _Nullable limit;

-(id _Nonnull)initWithContentType:(BVAuthorContentType)type limit:(NSNumber* _Nullable)limit;
-(NSString* _Nonnull)toParamString;


@end
