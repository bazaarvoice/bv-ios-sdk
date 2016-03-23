//
//  BVMessageInterceptor.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVMessageInterceptor.h"

@implementation BVMessageInterceptor

-(id)initWithMiddleman:(id)middleMan {
    self = [super init];
    if(self) {
        self.middleMan = middleMan;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) { return self.middleMan; }
    if ([self.receiver respondsToSelector:aSelector]) { return self.receiver; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) { return YES; }
    if ([self.receiver respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}

@end