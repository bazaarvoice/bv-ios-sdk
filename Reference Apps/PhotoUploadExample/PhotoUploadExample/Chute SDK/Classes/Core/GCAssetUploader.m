//
//  GCAssetUploader.m
//
//  Created by Achal Aggarwal on 08/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCAssetUploader.h"

static GCAssetUploader *sharedAssetUploader = nil;

@implementation GCAssetUploader

@synthesize queue;

#pragma mark - Step 1 - Make Parcel with Assets and Chutes
- (GCResponse *) createParcelWithAssets:(NSArray *) assets andChutes:(NSArray *) chutes {
    NSMutableArray *_assetsUniqueDescription = [[NSMutableArray alloc] init];
    for (GCAsset *_asset in assets) {
        [_assetsUniqueDescription addObject:[_asset uniqueRepresentation]];
    }
    
    NSDictionary *params    = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [_assetsUniqueDescription JSONRepresentation], @"files", 
                                   [chutes JSONRepresentation], @"chutes", 
                                   nil];
    
    [_assetsUniqueDescription release];
    
    NSString *_path = [[NSString alloc] initWithFormat:@"%@%@", API_URL, @"parcels"];
    
    GCRequest *gcRequest = [[GCRequest alloc] init];
    GCResponse *response = [[gcRequest postRequestWithPath:_path andParams:(NSMutableDictionary *)params] retain];
    
    [gcRequest release];
    [_path release];
    return [response autorelease];
}

#pragma mark - Step 2 - Remove already uploaded assets from the queue

#pragma mark - Step 3 - Generate token for Assets in the queue

#pragma mark - Step 4 - Upload assets to Amazon S3 using the token from previous request

#pragma mark - Step 5 - Send completion request for a particular asset


#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"queue"]) {
        //Check for GCAssets with status new and start uploading them... or reset a timer... if a new asset is added to the queue.
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Instance Methods

//TODO: Reset timer to 0 everytime addAsset is called. This delay will allow us to add more assets together
- (void) addAsset:(GCAsset *) anAsset {
    [[self queue] addObject:anAsset];
}

- (void) removeAsset:(GCAsset *) anAsset {
    [[self queue] removeObject:anAsset];
}

- (void) assetUpdated:(NSNotification *) notification {
    if ([[notification object] status] == GCAssetStateFinished) {
        [self removeAsset:[notification object]];
    }
}

#pragma mark - Methods for Singleton class
+ (GCAssetUploader *)sharedUploader
{
    if (sharedAssetUploader == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedAssetUploader = [[super allocWithZone:NULL] init];
        });
    }
    return sharedAssetUploader;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedUploader] retain];
}

- (id) init {
    self = [super init];
    if (self) {
        queue = [[NSMutableSet alloc] init];
        [self addObserver:self forKeyPath:@"queue" options:0 context:nil];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release;
{
    //nothing
}

- (id)autorelease
{
    return self;
}

- (void) dealloc {
    [queue release];
    [super dealloc];
}

@end
