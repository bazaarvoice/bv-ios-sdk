//
//  GCInvite.m
//  chute
//
//  Created by Brandon Coston on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCInvite.h"

@implementation GCInvite

+ (BOOL)supportsMetaData{
    return NO;
}
+ (NSString *)elementName{
    return @"invites";
}

+ (GCResponse *)all {
    NSString *_path         = [[NSString alloc] initWithFormat:@"%@inbox/%@", API_URL, [self elementName]];
    GCRequest *gcRequest    = [[GCRequest alloc] init];
    GCResponse *_response   = [[gcRequest getRequestWithPath:_path] retain];
    
    NSMutableArray *_result = [[NSMutableArray alloc] init];
    for (NSDictionary *_dic in [_response object]) {
        id _obj = [self objectWithDictionary:_dic];
        [_result addObject:_obj];
    }
    [_response setObject:_result];
    [_result release];
    [gcRequest release];
    [_path release];
    return [_response autorelease]; 
}

-(GCChute*)chute{
    GCChute *_chute = NULL;
    if([self objectForKey:@"chute"]){
        _chute = [GCChute objectWithDictionary:[self objectForKey:@"chute"]];
    }
    return _chute;
}
-(GCUser*)invited_by{
    GCUser *_invited_by = NULL;
    if([self objectForKey:@"invited_by"]){
        _invited_by = [GCUser objectWithDictionary:[self objectForKey:@"invited_by"]];
    }
    return _invited_by;
}


-(BOOL)accept{
    if (IS_NULL([self objectID])) {
        return NO;
    }
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%@/approve", API_URL, [[self class] elementName], [self objectID]];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    GCResponse *response        = [gcRequest postRequestWithPath:_path andParams:NULL];
    BOOL _response              = [response isSuccessful];
    [gcRequest release];
    [_path release];
    return _response;
    return NO;
}
-(void)acceptInBackgroundWithResponseBlock:(GCBoolBlock)boolBlock{
    DO_IN_BACKGROUND_BOOL([self accept], boolBlock);
}
-(BOOL)decline{
    GCResponse *response = [self destroy];
    if(response)
        return [response isSuccessful];
    return NO;
}
-(void)declineInBackgroundWithResponseBlock:(GCBoolBlock)boolBlock{
    DO_IN_BACKGROUND_BOOL([self decline], boolBlock);
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
