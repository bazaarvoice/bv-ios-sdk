//
//  GCAsset.m
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCAsset.h"
#import "GCAssetUploader.h"
#import "GC_UIImage+Extras.h"

NSString * const GCAssetStatusChanged   = @"GCAssetStatusChanged";
NSString * const GCAssetProgressChanged = @"GCAssetProgressChanged";
NSString * const GCAssetUploadComplete = @"GCAssetUploadComplete";

@implementation GCAsset

@synthesize alAsset;
@synthesize thumbnail;
@synthesize selected;
@synthesize progress;
@synthesize status;
@synthesize parentID;

// Public: Checks whether or not the asset has been hearted
//
// Returns YES if the asset is hearted and NO if it isn't.
- (BOOL) isHearted {
    if([[GCAccount sharedManager] heartedAssets])
        return [[[GCAccount sharedManager] heartedAssets] containsObject:self];
    return NO;
}

#pragma mark - Heart Method
// Public: toggles the hearted state of an asset
//
// Returns the hearted state of the asset after toggling it.
- (BOOL) toggleHeart {
    if ([self isHearted]) {
        //unheart
        GCResponse *response = [self unheart];
        if ([response isSuccessful]) {
            [[[GCAccount sharedManager] heartedAssets] removeObject:self];
        }
    }
    else {
        //heart
        GCResponse *response = [self heart];
        if ([response isSuccessful]) {
            [[[GCAccount sharedManager] heartedAssets] addObject:self];
        }
    }
    return [self isHearted];
}

// Public: Same as isHearted method except it runs on a background thread and executes
// a block of code after it finishes
//
// aBoolBlock - A block of code to run when the method is done
//
// No return value.
- (void) toggleHeartInBackgroundWithCompletion:(GCBoolBlock) aBoolBlock {
    DO_IN_BACKGROUND_BOOL([self toggleHeart], aBoolBlock);
}

// Public: Hearts the asset
//
// Returns a GCResponse with the result of the heart request.
- (GCResponse *) heart {
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@%@/%@/heart", API_URL, [[self class] elementName], [self objectID]];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    GCResponse *_response        = [[gcRequest postRequestWithPath:_path andParams:nil] retain];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

// Public: Same as heart except it runs on a background thread and executes
// a block of code after the request is completed
//
// aBoolErrorBlock - A block of code to run when the method finishes
//
// No return value.
- (void) heartInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock {
    DO_IN_BACKGROUND_BOOL_ERROR([self heart], aBoolErrorBlock);
}

// Public: Unhearts the asset
//
// Returns a GCResponse with the result of the unheart request.
- (GCResponse *) unheart {
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@%@/%@/unheart", API_URL, [[self class] elementName], [self objectID]];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    GCResponse *_response        = [[gcRequest postRequestWithPath:_path andParams:nil] retain];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

// Public: Same as unheart except it runs on a background thread and executes
// a block of code after the request is completed
//
// aBoolErrorBlock - A block of code to run when the method finishes
//
// No return value.
- (void) unheartInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock {
    DO_IN_BACKGROUND_BOOL_ERROR([self unheart], aBoolErrorBlock);
}

// Public: Uses the asset's alAsset data to determine if the Asset exists on the server
// and whether or not it has already been uploaded
//
// Returns a GCResponse with it's object set to an array of dictionaries with info for each matching asset.
-(GCResponse*)verify{
    if(![self alAsset]){
        GCResponse *response = [[GCResponse alloc] init];
        NSMutableDictionary *_errorDetail = [NSMutableDictionary dictionary];
        [_errorDetail setValue:@"No asset info to to send" forKey:NSLocalizedDescriptionKey];
        [response setError:[GCError errorWithDomain:@"GCError" code:401 userInfo:_errorDetail]];
        return [response autorelease];
    }
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@%@/verify", API_URL, [[self class] elementName]];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[[NSArray arrayWithObject:[self uniqueRepresentation]] JSONRepresentation] forKey:@"files"];
    GCResponse *_response        = [[gcRequest postRequestWithPath:_path andParams:params] retain];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

#pragma mark - Comment Methods
// Public: Retrives the comments for an asset in a particular chute from the server
//
// The asset must have the parentID set to whatever chute the asset is in that you want to comment on.
//
// Returns a GCResponse object with an array of GCComments set to it's object.
- (GCResponse *) comments {
    if (IS_NULL([self parentID])) {
        return nil;
    }
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@chutes/%@/assets/%@/comments", API_URL, [self parentID], [self objectID]];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    GCResponse *_response        = [[gcRequest getRequestWithPath:_path] retain];
    NSMutableArray *_comments    = [[NSMutableArray alloc] init]; 
    for (NSDictionary *_dic in [_response data]) {
        [_comments addObject:[GCComment objectWithDictionary:_dic]];
    }
    [_response setObject:_comments];
    [_comments release];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

// Public: Same as comments except runs in background and executes a completion block after finishing the request
//
// aResponseBlock - the block of code to execute after the request is finished
//
// No return value.
- (void) commentsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self comments], aResponseBlock);
}

// Public: Adds a comment to an asset in a particular chute
//
// The asset must have the parentID set to whatever chute the asset is in that you want to comment on.
// _comment - The comment to be added.
//
// Returns a GCResponse object with the results of the request.
- (GCResponse *) addComment:(NSString *) _comment {
    if (IS_NULL([self parentID])) {
        return nil;
    }
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:_comment forKey:@"comment"];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@chutes/%@/assets/%@/comments", API_URL, [self parentID], [self objectID]];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    GCResponse *_response       = [[gcRequest postRequestWithPath:_path andParams:_params] retain];
    [gcRequest release];
    [_path release];
    [_params release];
    return [_response autorelease];
}

// Public: Same as addComment except runs in background and executes a completion block after finishing the request
//
// _comment - The comment to add
// aResponseBlock - the block of code to execute after the request is finished
//
// No return value.
- (void) addComment:(NSString *) _comment inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self addComment:_comment], aResponseBlock);
}

// Public: Creates a representation of the Asset that can uniquely identify it for the device when making server requests.
//
// Returns a NSDictionary with filename, size and md5 properties.  If the asset has them it also includes an id and status property.
- (NSDictionary *) uniqueRepresentation {
    if([self alAsset]){
        ALAssetRepresentation *_representation = [[self alAsset] defaultRepresentation];
        if([self objectID]){
            return [NSDictionary dictionaryWithObjectsAndKeys:[[_representation url] absoluteString], @"filename", 
                    [NSString stringWithFormat:@"%lld", [_representation size]], @"size", 
                    [NSString stringWithFormat:@"%lld", [_representation size]], @"md5",
                    [self objectID], @"id",
                    [NSNumber numberWithInt:[self status]], @"status",
                    nil];
        }
        return [NSDictionary dictionaryWithObjectsAndKeys:[[_representation url] absoluteString], @"filename", 
                [NSString stringWithFormat:@"%lld", [_representation size]], @"size", 
                [NSString stringWithFormat:@"%lld", [_representation size]], @"md5", 
                nil];
    }
    return nil;
}

// Public: retrieves the filepath of the asset on the device if the asset has an alAsset associated with it.
//
// Returns the filepath as given by the url of the alAsset
- (NSString *) uniqueURL {
    return [[[[self alAsset] defaultRepresentation] url] absoluteString];
}

#pragma mark - Upload

- (void) upload {
    [[GCAssetUploader sharedUploader] addAsset:self];
}

#pragma mark - Accessors Override
// Public: Initializes a UIImage with a thumbnail for the Asset
//
// Returns a UIImage initialized with a thumbnail of the image, either from the server or the local copy if it has an alAsset.
- (UIImage *) thumbnail {
    if ([self alAsset]) {
        return [UIImage imageWithCGImage:[[self alAsset] thumbnail]];
    }
    else if([self status] == GCAssetStateFinished) {
        return [self imageForWidth:75 andHeight:75];
    }
    return nil;
}

// Public: Adjusts the progress of the asset during uploads
//
// aProgress - the new progress value from 0.0 to 1.0
//
// no return value
- (void) setProgress:(CGFloat)aProgress {
    progress = aProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:GCAssetProgressChanged object:self];
}

// Public: Adjusts the Status of the asset during uploads and initialization
//
// aStatus - the new status of the asset
//
// no return Value
- (void) setStatus:(GCAssetStatus)aStatus {
    if (status == GCAssetStateCompleting && aStatus == GCAssetStateFinished) {
        status = aStatus;
        [[NSNotificationCenter defaultCenter] postNotificationName:GCAssetUploadComplete object:self];
    }
    
    status = aStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:GCAssetStatusChanged object:self];
}

// Public: Creates a string version of the url for displaying an asset for a given height and width
//
// width - the width (in pixels) of the image
// height - the height (in pixels) of the image
//
// Returns the url of the image data.
- (NSString*)urlStringForImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    if ([self status] == GCAssetStateNew)
        return nil;
    
    NSString *urlString = [self objectForKey:@"url"];
    
    if(urlString)
        urlString   = [urlString stringByAppendingFormat:@"/%dx%d",width,height];
    return urlString;
}

// Public: Creates a UIImage for the asset that is a given width and height.  It uses the local copy if an alAsset is set otherwise it gets the image from the server.
//
// width - the width (in pixels) of the image
// height - the height (in pixels) of the image
//
// Returns a UIImage of the asset initialized with the given height and width.
- (UIImage *)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    if ([self alAsset]) {
        UIImage *fullResolutionImage = [UIImage imageWithCGImage:[[[self alAsset] defaultRepresentation] fullResolutionImage] scale:1 orientation:[[[self alAsset] valueForProperty:ALAssetPropertyOrientation] intValue]];
        return [fullResolutionImage imageByScalingProportionallyToSize:CGSizeMake(width, height)];
    }
    
    NSString *urlString = [self urlStringForImageWithWidth:width andHeight:height];
    
    NSURL *url      = [NSURL URLWithString:urlString];
    NSData *data    = [NSData dataWithContentsOfURL:url];
    UIImage *image  = nil;
    
    if(data)
        image = [UIImage imageWithData:data];
    return image;
}

// Public: same as imageForWidth:andHeight: except it runs in the background and executes a block of code when finished.
//
// width - the width (in pixels) of the image
// height - the height (in pixels) of the image
// aResponseBlock - The code to execute after the image is retreived
//
// No return value
- (void)imageForWidth:(NSUInteger)width 
            andHeight:(NSUInteger)height 
inBackgroundWithCompletion:(void (^)(UIImage *))aResponseBlock {    
    DO_IN_BACKGROUND([self imageForWidth:width andHeight:height], aResponseBlock);
}

// Public: Retrieves the date the asset was created
//
// Returns an NSDate initialized with the asset's creation date.
- (NSDate*)createdAt{
    if(self.alAsset){
        return [self.alAsset valueForProperty:ALAssetPropertyDate];
    }
    return [super createdAt];
}

#pragma mark - Memory Management
// Public: Initializes a blank asset with a new status
//
// Returns self, the newly initialized asset.
- (id) init {
    self = [super init];
    if (self) {
        [self setStatus:GCAssetStateNew];
    }
    return  self;
}

// Public: Initializes an asset with the given dictionary information.
//
// dictionary - a NSDictionary representation of the data to initialize the asst with.
//
// Returns self, the newly initialized asset.
- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if([dictionary objectForKey:@"status"])
            [self setStatus:[[dictionary objectForKey:@"status"] intValue]];
        else
            [self setStatus:GCAssetStateFinished];
        if(![self objectID]){
            if([self objectForKey:@"asset_id"])
                [self setObject:[self objectForKey:@"asset_id"] forKey:@"id"];
        }
    }
    return self;
}

// Public: deallocates the asset, releasing retained objects.
//
// no return value
- (void) dealloc {
    [parentID release];
    [alAsset release];
    [super dealloc];
}

#pragma mark - Super Class Methods

// Public: Returns @"asset", used for API calls for subclassing.
//
// returns @"asset"
+ (NSString *)elementName {
    return @"assets";
}

// Public: Checks equality of two assets
//
// Returns YES if they are equal or NO if they aren't
- (BOOL) isEqual:(id)object {
    if (IS_NULL([self objectID]) && IS_NULL([object objectID])) {
        if([self alAsset] && [object alAsset])
            return [[self alAsset] isEqual:[object alAsset]];
        else
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

// Public: A hash function for the asset, mostly used if storing in a set
//
// Returns an integer hash for the asset
-(NSUInteger)hash{
    if(IS_NULL([self objectID])){
        if([self alAsset])
            return [[self alAsset] hash];
        else
            return [super hash];
    }
    return [[self objectID] hash];
}

@end
