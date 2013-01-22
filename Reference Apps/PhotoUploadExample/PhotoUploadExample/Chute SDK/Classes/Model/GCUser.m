//
//  GCUser.m
//
//  Created by Achal Aggarwal on 07/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCUser.h"

@implementation GCUser

@synthesize name;
@synthesize avatarURL;

#pragma mark - Accessor Methods
- (NSString *)name
{
    return [[[self objectForKey:@"name"] retain] autorelease]; 
}
- (void)setName:(NSString *)aName
{
    [aName retain];
    [self setObject:aName forKey:@"name"];
    [aName release];
}

- (NSString *)avatarURL
{
    return [[[self objectForKey:@"avatar"] retain] autorelease]; 
}

- (void)setAvatarURL:(NSString *)anAvatarURL
{
    [anAvatarURL retain];
    [self setObject:anAvatarURL forKey:@"avatar"];
    [anAvatarURL release];
}



- (BOOL) isEqual:(id)object {
    if (IS_NULL([self objectID]) && IS_NULL([object objectID])) {
        return [super isEqual:object];
    }
    if (IS_NULL([self objectID]) || IS_NULL([object objectID])) {
        return NO;
    }
    
    if ([[self objectID] intValue] == [[object objectID] intValue]) {
        return YES;
    }
    return NO;
}

-(NSUInteger)hash{
    if(IS_NULL([self objectID]))
        return [super hash];
    return [[self objectID] hash];
}

@end
