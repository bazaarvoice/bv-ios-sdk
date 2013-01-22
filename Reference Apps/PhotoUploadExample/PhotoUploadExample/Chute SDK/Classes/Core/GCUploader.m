//
//  GCUploader.m
//
//  Created by Achal Aggarwal on 09/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCUploader.h"

static GCUploader *sharedUploader = nil;

NSString * const GCUploaderProgressChanged = @"GCUploaderProgressChanged";
NSString * const GCUploaderFinished = @"GCUploaderFinished";

@interface GCUploader()
- (void) processQueue;
@end

@implementation GCUploader

@synthesize queue = _queue;
@synthesize progress;

+ (void) uploadImage:(UIImage*)image toChute:(GCChute*)chute{
    if(![[GCAccount sharedManager] assetsLibrary]){
        ALAssetsLibrary *temp = [[ALAssetsLibrary alloc] init];
        [[GCAccount sharedManager] setAssetsLibrary:temp];
        [temp release];
    }
    ALAssetsLibrary *library = [[GCAccount sharedManager] assetsLibrary];
    [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:[NSDictionary dictionary] completionBlock:^(NSURL *assetURL, NSError *error){
        if(!error){
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset){
                GCAsset *temp = [[[GCAsset alloc] init] autorelease];
                [temp setAlAsset:asset];
                GCParcel *parcel = [GCParcel objectWithAssets:[NSArray arrayWithObject:temp] andChutes:[NSArray arrayWithObject:chute]];
                [[GCUploader sharedUploader] addParcel:parcel];
            } failureBlock:^(NSError *error){
                NSLog(@"finding asset failed");
            }];
        }
    }];
}

+ (void) uploadArrayOfImages:(NSArray*)images toChute:(GCChute*)chute{
    NSMutableArray *array = [NSMutableArray array];
    for(id image in images){
        if(![[GCAccount sharedManager] assetsLibrary]){
            ALAssetsLibrary *temp = [[ALAssetsLibrary alloc] init];
            [[GCAccount sharedManager] setAssetsLibrary:temp];
            [temp release];
        }
        ALAssetsLibrary *library = [[GCAccount sharedManager] assetsLibrary];
        [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:[NSDictionary dictionary] completionBlock:^(NSURL *assetURL, NSError *error){
            if(!error){
                [library assetForURL:assetURL resultBlock:^(ALAsset *asset){
                    GCAsset *temp = [[[GCAsset alloc] init] autorelease];
                    [temp setAlAsset:asset];
                    [array addObject:temp];
                    if([array count] == [images count]){
                        GCParcel *parcel = [GCParcel objectWithAssets:array andChutes:[NSArray arrayWithObject:chute]];
                        [[GCUploader sharedUploader] addParcel:parcel];
                    }
                } failureBlock:^(NSError *error){
                    NSLog(@"finding asset failed");
                }];
            }
        }];
    }
}

+ (void) uploadAsset:(GCAsset*)asset toChute:(GCChute*)chute{
    if([asset alAsset]){
        GCParcel *parcel = [GCParcel objectWithAssets:[NSArray arrayWithObject:asset] andChutes:[NSArray arrayWithObject:chute]];
        [[GCUploader sharedUploader] addParcel:parcel];
    }
}

+ (void) uploadArrayOfAssets:(NSArray*)assets toChute:(GCChute*)chute{
    GCParcel *parcel = [GCParcel objectWithAssets:assets andChutes:[NSArray arrayWithObject:chute]];
    [[GCUploader sharedUploader] addParcel:parcel];
}

- (int) queueParcelCount{
    if(self.queue)
        return self.queue.count;
    return 0;
}
- (int) queueAssetCount{
    if(self.queue){
        int i = 0;
        for(GCParcel *parcel in self.queue){
            i += parcel.assets.count;
        }
        return i;
    }
    return 0;
}

- (void) updateProgress:(NSNotification *) notification {
    float total = 0.0;
    int totalAssets = 0;
    for (GCParcel *_parcel in self.queue) {
        totalAssets += [_parcel assetCount];
        if (_parcel == [self.queue objectAtIndex:0]) {
            //calculate asset progress
            for (GCAsset *_asset in [_parcel assets]) {
                total += [_asset progress]; 
            }
            total += [_parcel completedAssetCount];
        }
    }
    [self setProgress:total/totalAssets];
}

- (void) setProgress:(CGFloat)aProgress {
    progress = aProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:GCUploaderProgressChanged object:nil];
}

- (void) parcelCompleted {
    if ([self.queue count] > 0) {
        [self.queue removeObjectAtIndex:0];
    }
    
    if ([[self queue] count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GCUploaderFinished object:nil];
    }
    [self backupQueueToUserDefaults];
    [self processQueue];
}

- (void) processQueue {
    if ([[self queue] count] > 0) {
        GCParcel *_parcel = [self.queue objectAtIndex:0];
        [_parcel startUploadWithTarget:self andSelector:@selector(parcelCompleted)];
    }
}

- (void) backupQueueToUserDefaults{
    NSMutableArray *array = [NSMutableArray array];
    for(GCParcel *parcel in self.queue){
        NSDictionary *dictionary = [parcel dictionaryRepresentation];
        if(dictionary){
            [array addObject:dictionary];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"GCUPLOADQUEUE"];
}
- (void) loadQueueFromUserDefaults{
    NSArray *array = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GCUPLOADQUEUE"]];
    [self setQueue:[NSMutableArray array]];
    for(NSDictionary *dictionary in array){
        GCParcel *parcel = [[GCParcel alloc] initWithDictionaryRepresentation:dictionary];
        [self.queue addObject:[parcel autorelease]];
    }
    [self processQueue];
}

- (void) addParcel:(GCParcel *) _parcel {
    [self.queue addObject:_parcel];
    [self backupQueueToUserDefaults];
    [self processQueue];
}

- (void) removeParcel:(GCParcel *) _parcel {
    [self.queue removeObject:_parcel];
    [self backupQueueToUserDefaults];
    [self processQueue];
}

#pragma mark - Methods for Singleton class
+ (GCUploader *)sharedUploader
{
    if (sharedUploader == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedUploader = [[super allocWithZone:NULL] init];
        });
    }
    return sharedUploader;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedUploader] retain];
}

- (id) init {
    self = [super init];
    if (self) {
        [self setQueue:[NSMutableArray array]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:GCAssetProgressChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupQueueToUserDefaults) name:GCAssetUploadComplete object:nil];
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
    [_queue release];
    [super dealloc];
}

@end
