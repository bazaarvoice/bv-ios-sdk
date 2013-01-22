//
//  GCComment.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/9/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCComment.h"

@implementation GCComment

-(GCChute*)chute{
    GCChute *_chute = NULL;
    if([self objectForKey:@"chute"]){
        _chute = [GCChute objectWithDictionary:[self objectForKey:@"chute"]];
    }
    return _chute;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
