//
//  GCConfiguration.m
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 8/10/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "GCConfiguration.h"
#import "GCAccount.h"
#import "NSObject+GCDictionary.h"
#import <Chute-SDK/GCOAuth2Client.h>
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>

static NSString * const kGCServices = @"services";
static NSString * const kGCLocalFeatures = @"local_features";
static NSString * const kGCOAuth = @"oauth";
static NSString * const kGCAccounts = @"accounts";

static NSString * const kGCConfiguration = @"GCConfiguration";
static NSString * const kGCExtension = @"plist";
static NSString * const kGCConfigurationURL = @"https://dl.dropboxusercontent.com/u/23635319/ChuteAPI/config.json";

static GCConfiguration *sharedData = nil;
static dispatch_queue_t serialQueue;

static NSSet *_sLocalFeatures;
static NSDictionary *_dServiceFeatures;

@implementation GCConfiguration

@synthesize services, localFeatures, oauthData, accounts;

+(id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.getchute.gcconfiguration", NULL);
        if (sharedData == nil) {
            sharedData = [super allocWithZone:zone];
        }
    });
    
    return sharedData;
}

+(GCConfiguration *)configuration {
    static dispatch_once_t onceToken;
    static GCConfiguration *sharedData = nil;
    
    dispatch_once(&onceToken, ^{
        sharedData = [[GCConfiguration alloc] init];
    });
    return sharedData;
}

- (id)init
{
    id __block obj;
    
    dispatch_sync(serialQueue, ^{
        
        obj = [super init];
        
        if (obj) {
            
            _sLocalFeatures = [NSSet setWithArray:@[@"take_photo", @"last_taken_photo", @"camera_photos"]];
            _dServiceFeatures = @{@"facebook":@"facebook",
                                  @"google": @"google",
                                  @"googledrive": @"google",
                                  @"instagram": @"instagram",
                                  @"flickr": @"flickr",
                                  @"picasa": @"google",
                                  @"dropbox": @"dropbox",
                                  @"skydrive": @"microsoft_account",
                                  @"twitter":@"twitter",
                                  @"chute":@"chute",
                                  @"foursquare":@"foursquare"
                                  };
           
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kGCConfiguration, kGCExtension]];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:path]) {
                path = [[NSBundle mainBundle] pathForResource:kGCConfiguration ofType:kGCExtension];
                
            }
            
            NSDictionary *savedStock = [[NSDictionary alloc] initWithContentsOfFile: path];
            [self setConfiguration:savedStock];
            
            [self update];
        }
    });
    
    self = obj;
    return self;
}

- (void)update
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kGCConfigurationURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSDictionary *configuration = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!error) {
                [self setConfiguration:configuration];
            }
        }
    }];
}

- (void)addAccount:(GCAccount *)account
{
    if (![self accounts])
        self.accounts = [NSMutableArray new];
    
    for (int i = 0; i < [self.accounts count]; i++) {
        if ([account.type isEqualToString:[self.accounts objectAtIndex:i]]) {
            [self.accounts removeObjectAtIndex:i];
            i--;
        }
    }
    
    [self.accounts addObject:account];
    [self serialize];
}

- (void)setConfiguration:(NSDictionary *)configuration
{
    if ([configuration objectForKey:kGCOAuth]){
        
        self.oauthData = [configuration objectForKey:kGCOAuth];
    }
    if ([configuration objectForKey:kGCServices]){
        
        NSMutableArray *tmpServices = [NSMutableArray array];
        
        [[configuration objectForKey:kGCServices] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if([[_dServiceFeatures allKeys] containsObject:obj]) {
                
//                NSString *loginTypeString = [_dServiceFeatures objectForKey:obj];
//                GCLoginType *loginType = [self loginTypeForString:loginTypeString];
                
                [tmpServices addObject:obj];
            }
//            
//            if ([GCOAuth2Client serviceForString:obj] != -1) {
//                [tmpServices addObject:obj];
//            }
        }];
        self.services = [NSArray arrayWithArray:tmpServices];
    }
    if ([configuration objectForKey:kGCLocalFeatures]){
        
        NSMutableArray *tmpLocalFeatures = [NSMutableArray array];
        
        [[configuration objectForKey:kGCLocalFeatures] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([_sLocalFeatures containsObject:obj]) {
                [tmpLocalFeatures addObject:obj];
            }
        }];
        self.localFeatures = [NSArray arrayWithArray:tmpLocalFeatures];
    }
    if ([configuration objectForKey:kGCAccounts]) {
        
        DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCAccount class]];
        self.accounts = [NSMutableArray arrayWithArray:[mapping parseArray:[configuration objectForKey:kGCAccounts]]];
    }
    
    [self serialize];
}

- (void)serialize
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kGCConfiguration, kGCExtension]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        [fileManager removeItemAtPath:path error:&error];
    }
    if (![fileManager fileExistsAtPath: path])
    {
        NSMutableDictionary *stockToSave = [[NSMutableDictionary alloc] init];
        if ([self services])
        {
            [stockToSave setObject:services forKey:kGCServices];
        }
        if ([self localFeatures])
        {
            [stockToSave setObject:localFeatures forKey:kGCLocalFeatures];
        }
        if ([self oauthData])
        {
            [stockToSave setObject:oauthData forKey:kGCOAuth];
        }
        
        if ([self accounts]) {
            NSMutableArray *accountDictionaries = [NSMutableArray new];
            for (GCAccount *account in [self accounts]) {
                [accountDictionaries addObject:[account dictionaryValue]];
            }
            [stockToSave setObject:accountDictionaries forKey:kGCAccounts];
        }
        
        [stockToSave writeToFile:path atomically:YES];
    }
}

- (GCLoginType)loginTypeForString:(NSString *)serviceString
{
    __block NSString *loginType = [_dServiceFeatures objectForKey:serviceString];
    
    for (int i = 0; i <kGCLoginTypeCount; i++) {
        if ([loginType isEqualToString:kGCLoginTypes[i]]){
            return i;
        }
    }
    return -1;
}

- (NSString *)loginTypeString:(GCLoginType)loginType
{
    if(loginType >= kGCLoginTypeCount)
        return @"";
    return kGCLoginTypes[loginType];
}

@end
