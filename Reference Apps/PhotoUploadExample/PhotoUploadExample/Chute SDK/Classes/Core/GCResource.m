//
//  GCResource.m
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCResource.h"
#import "GCResponse.h"
#import "GCUser.h"

@interface GCResource()

+ (NSString *)elementName;
- (id) initWithDictionary:(NSDictionary *) dictionary;

@end

@implementation GCResource

@synthesize content = _content;

#pragma mark - All 
/* Get all Objects of this class */
+ (GCResponse *)all {
    NSString *_path         = [[NSString alloc] initWithFormat:@"%@me/%@", API_URL, [self elementName]];
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

+ (void)allInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {      
    DO_IN_BACKGROUND([self all], aResponseBlock);
}

+ (GCResponse *)findById:(NSString *) objectID {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%@", API_URL, [self elementName], objectID];
    GCRequest *gcRequest      = [[GCRequest alloc] init];

    GCResponse *_response        = [[gcRequest getRequestWithPath:_path] retain];
    [_response setObject:[self objectWithDictionary:[_response object]]];
    
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

+ (void)findById:(NSString *) objectID inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self findById:objectID], aResponseBlock);
}

+ (GCResponse *)findByShortcut:(NSString *) objectID {
    return [self findById:objectID];
}

+ (void)findByShortcut:(NSString *) objectID inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self findByShortcut:objectID], aResponseBlock);
}

#pragma mark - Override these methods in every Subclass
+ (NSString *)elementName {
    //for example, this should return the string "chutes", "assets", "bundles", "parcels"
    NSAssert(0, @"Please override the elementName class method in your subclass");
    return nil;
}

+ (BOOL)supportsMetaData {
    return YES;
}

#pragma mark - Instance Methods
#pragma mark - Init

- (id) init {
    self = [super init];
    if (self) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id) objectWithDictionary:(NSDictionary *) dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [self init];
    if(self){
        for (NSString *key in [dictionary allKeys]) {
            id _obj;
            if ([key isEqualToString:@"user"]) {
                _obj = [GCUser objectWithDictionary:[dictionary objectForKey:key]];
            }
            else {
                _obj = IS_NULL([dictionary objectForKey:key])? @"": [dictionary objectForKey:key];
            }
            [self setObject:_obj forKey:key];
        }
    }
    return self;
}

- (void) dealloc {
    [_content release];
    [super dealloc];
}

- (void)setObject:(id) aObject forKey:(id)aKey {
    [_content setObject:aObject forKey:aKey];
}

- (id)objectForKey:(id)aKey {
    return [_content objectForKey:aKey];
}

#pragma mark - Proxy for JSONRepresentation
- (id)proxyForJson {
    return _content;
}

#pragma mark - Common Meta Data Methods

+ (GCResponse *) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value {
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/meta/%@/%@", API_URL, [[self class] elementName], IS_NULL(key)?@"":key, IS_NULL(value)?@"":value];
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    GCResponse *_response       = [[gcRequest getRequestWithPath:_path] retain];
    
    NSMutableArray *_result     = [[NSMutableArray alloc] init];
    for (NSDictionary *_dic in [[_response object] objectForKey:[self elementName]]) {
        id _obj = [self objectWithDictionary:_dic];
        [_result addObject:_obj];
    }
    [_response setObject:_result];
    [_result release];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

+ (void) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self searchMetaDataForKey:key andValue:value], aResponseBlock);
}

- (GCResponse *) getMetaData {
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@%@/%@/meta", API_URL, [[self class] elementName], [self objectID]];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    GCResponse *_response        = [[gcRequest getRequestWithPath:_path] retain];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

- (void) getMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self getMetaData], aResponseBlock);
}

- (GCResponse *) getMetaDataForKey:(NSString *) key {
    if (IS_NULL([self objectID])) {
        return nil;
    }
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%@/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    GCRequest *gcRequest          = [[GCRequest alloc] init];
    GCResponse *_response         = [[gcRequest getRequestWithPath:_path] retain];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

- (void) getMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self getMetaDataForKey:key], aResponseBlock);
}

- (BOOL) setMetaData:(NSDictionary *) metaData {
    if (IS_NULL([self objectID])) {
        return NO;
    }
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[[metaData JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];

    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%@/meta", API_URL, [[self class] elementName], [self objectID]];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    BOOL _response              = [[gcRequest postRequestWithPath:_path andParams:_params] isSuccessful];
    [gcRequest release];
    [_path release];
    [_params release];
    return _response;
}

- (void) setMetaData:(NSDictionary *) metaData inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock {
    DO_IN_BACKGROUND_BOOL([self setMetaData:metaData], aBoolBlock);
}

- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key {
    if (IS_NULL([self objectID])) {
        return NO;
    }
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[data dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%@/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    BOOL _response              = [[gcRequest postRequestWithPath:_path andParams:_params] isSuccessful];
    [gcRequest release];
    [_path release];
    [_params release];
    return _response;
}

- (void) setMetaData:(NSString *) data forKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock {
    DO_IN_BACKGROUND_BOOL([self setMetaData:data forKey:key], aBoolBlock);
}

- (BOOL) deleteMetaData {
    if (IS_NULL([self objectID])) {
        return NO;
    }
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%@/meta", API_URL, [[self class] elementName], [self objectID]];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    BOOL _response              = [[gcRequest deleteRequestWithPath:_path andParams:nil] isSuccessful];
    [gcRequest release];
    [_path release];
    return _response;
}

- (void) deleteMetaDataInBackgroundWithCompletion:(GCBoolBlock) aBoolBlock {
    DO_IN_BACKGROUND_BOOL([self deleteMetaData], aBoolBlock);
}

- (BOOL) deleteMetaDataForKey:(NSString *) key {
    if (IS_NULL([self objectID])) {
        return NO;
    }
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%@/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    BOOL _response              = [[gcRequest deleteRequestWithPath:_path andParams:nil] isSuccessful];
    [gcRequest release];
    [_path release];
    return _response;
}

- (void) deleteMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock {
    DO_IN_BACKGROUND_BOOL([self deleteMetaDataForKey:key], aBoolBlock);
}

#pragma mark - Common Data Getters
- (GCUser *) user {
    if(_content)
        return [_content objectForKey:@"user"];
    return nil;
}

- (NSString *) objectID {
    if(_content){
        if(!IS_NULL([_content objectForKey:@"id"]))
            return [NSString stringWithFormat:@"%@",[_content objectForKey:@"id"]];
    }
    return NULL;
}

- (NSDate *) updatedAt {
    if (IS_NULL([self objectForKey:@"updated_at"])) {
        return nil;
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *_date = [_formatter dateFromString:[self objectForKey:@"updated_at"]];
    [_formatter release];
    return _date;
}

- (NSDate *) createdAt {
    if (IS_NULL([self objectForKey:@"created_at"])) {
        return nil;
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *_date = [_formatter dateFromString:[self objectForKey:@"created_at"]];
    [_formatter release];
    return _date;
}

#pragma mark - Instance Method Calls
- (GCResponse *) save {
    NSString *_data = [[NSString alloc] initWithFormat:@"{ \"data\":%@ }", [self JSONRepresentation]];
    
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[_data dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];
    
    [_data release];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@", API_URL, [[self class] elementName]];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    GCResponse *_response       = [[gcRequest postRequestWithPath:_path andParams:_params] retain];
    
    if ([_response isSuccessful]) {
        //Update the current object with the new values
        for (NSString *key in [[_response object] allKeys]) {
            [self setObject:[[_response object] objectForKey:key] forKey:key];
        }
    }

    [gcRequest release];
    [_path release];
    [_params release];
    
    return [_response autorelease];
}

- (void) saveInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock {
    DO_IN_BACKGROUND_BOOL_ERROR([self save], aBoolErrorBlock);
}

- (GCResponse *) update {
    if (IS_NULL([self objectID])) {
        return NO;
    }
    NSString *_data = [[NSString alloc] initWithFormat:@"{ \"data\":%@ }", [self JSONRepresentation]];
    
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[_data dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];
    
    [_data release];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%@", API_URL, [[self class] elementName], [self objectID]];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    GCResponse *_response       = [[gcRequest putRequestWithPath:_path andParams:_params] retain];
    
    if ([_response isSuccessful]) {
        //Update the current object with the new values
        for (NSString *key in [[_response object] allKeys]) {
            [self setObject:[[_response object] objectForKey:key] forKey:key];
        }
    }

    [gcRequest release];
    [_path release];
    [_params release];
    
    return [_response autorelease];
}

- (void) updateInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock {
    DO_IN_BACKGROUND_BOOL_ERROR([self update], aBoolErrorBlock);
}

- (GCResponse *) destroy {
    if (IS_NULL([self objectID])) {
        return NO;
    }
    NSString *_path        = [[NSString alloc] initWithFormat:@"%@%@/%@", API_URL, [[self class] elementName], [self objectID]];
    
    GCRequest *gcRequest   = [[GCRequest alloc] init];
    GCResponse *_response   = [[gcRequest deleteRequestWithPath:_path andParams:nil] retain];
    
    if ([_response isSuccessful]) {
        [_content release], _content = nil;
        _content = [[NSMutableDictionary alloc] init];
    }
    
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

- (void) destroyInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock {
    DO_IN_BACKGROUND_BOOL_ERROR([self destroy], aBoolErrorBlock);
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@:\n%@", [super description], _content];
}

@end
