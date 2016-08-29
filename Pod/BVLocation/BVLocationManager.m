//
//  BVLocationManager.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import "BVLocationManager.h"
#import "BVLogger.h"
#import "BVSDKManager.h"
#import <Gimbal/Gimbal.h>
#import "BVVisit.h"
#import "BVPlaceAttributes.h"
#import "BVLocationAnalyticsHelper.h"

@interface DelegateContainer : NSObject
@property (nonatomic, weak) id<BVLocationManagerDelegate> delegate;
@end

@implementation DelegateContainer
@end

@interface BVLocationManager()

@property (nonatomic, strong) GMBLPlaceManager *placeManager;
@property (nonatomic, strong) GMBLCommunicationManager *communicationManager;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSMutableArray *registeredDelegates;
@property (nonatomic, weak) id<BVLocationNotificationDelegate> notificationDelegate;

@end

@implementation BVLocationManager

+(void)load{
    [self sharedManager];
}

+(id)sharedManager {
    static BVLocationManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    
    return shared;
}

- (id)init {
    if (self = [super init]) {
        _registeredDelegates = [NSMutableArray new];
        [[BVSDKManager sharedManager] addObserver:self forKeyPath:@"apiKeyLocation" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)initGimbal {
    
    NSAssert([[[BVSDKManager sharedManager] clientId] length], @"You must supply client id in the BVSDKManager before using the Bazaarvoice SDK.");
    if ([self.class isValidUUID:_apiKey]) {
        
        [[BVLogger sharedLogger] verbose:@"Initializing Location Manager"];
        
        [Gimbal setAPIKey:_apiKey options:nil];
        
        _placeManager = [[GMBLPlaceManager alloc]init];
        _placeManager.delegate = (id)self;
        
        _communicationManager = [[GMBLCommunicationManager alloc]init];
        _communicationManager.delegate = (id)self;
        
        
    }else {
        NSAssert(NO, @"You must provide a valid Location API Key before using BVLocation");
    }
}

+ (BOOL)isValidUUID:(NSString *)UUIDString
{
    NSUUID* UUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
    if(UUID)
        return true;
    else
        return false;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"apiKeyLocation"]){
        _apiKey = [object valueForKeyPath:keyPath];
        [self initGimbal];
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (void)startLocationUpdates{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
        
        NSAssert([[self sharedManager] apiKey], @"Unable to start updating location. BVLocation API Key not set");
        [GMBLPlaceManager startMonitoring];
        [GMBLCommunicationManager startReceivingCommunications];
        [[BVLogger sharedLogger] verbose:@"Successfully started updating location."];
        
    }else{
        [[BVLogger sharedLogger] verbose:@"Unable to start updating location. Insufficent permission"];
    }
}

+ (void)stopLocationUpdates {
    [GMBLPlaceManager stopMonitoring];
    [GMBLCommunicationManager stopReceivingCommunications];
}

#pragma mark GMBLPlaceManagerDelegate

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit {
    
    GMBLAttributes *attributes = visit.place.attributes;
    NSDictionary *attributeDictionary = [self gimbalAttributesToDictionary:attributes];
    
    if ([self gimbalPlaceIsValid:visit.place]) {
        [BVLocationAnalyticsHelper queueAnalyticsEventForGimbalVisit:visit];
    }
    
    [self callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributeDictionary];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit {
    GMBLAttributes *attributes = visit.place.attributes;
    NSDictionary *attributeDictionary = [self gimbalAttributesToDictionary:attributes];
    
    if ([self gimbalPlaceIsValid:visit.place]) {
        [BVLocationAnalyticsHelper queueAnalyticsEventForGimbalVisit:visit];
    }
    
    [self callbackToDelegates:@selector(didEndVisit:) withAttributes:attributeDictionary];
}

-(BOOL)gimbalPlaceIsValid:(GMBLPlace*)place {
    return [place.attributes stringForKey:@"id"];
}

-(NSDictionary*)gimbalAttributesToDictionary:(GMBLAttributes*)attributes {
    
    NSMutableDictionary *attributeDictionary = [NSMutableDictionary new];
    
    for (NSString *key in attributes.allKeys) {
        [attributeDictionary setObject:[attributes stringForKey:key] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:attributeDictionary];
}

- (void)callbackToDelegates:(SEL)selector withAttributes:(NSDictionary *)attributes{
    
    if(!_registeredDelegates.count) {
        return;
    }
    
    NSString *type = [attributes objectForKey:PLACE_TYPE_KEY];
    
    if ([BVPlaceAttributes typeFromString:type] != PlaceTypeGeofence) {
        return;
    }
    
    NSString *clientId = [attributes objectForKey:PLACE_CLIENT_ID];
    
    if (![clientId isEqualToString:[BVSDKManager sharedManager].clientId]) {
        return;
    }
    
    
    NSArray *delegates = [NSArray arrayWithArray:_registeredDelegates];
    for ( DelegateContainer *container in delegates){
        
        if (container.delegate) {
            
            BVVisit *visit = [self attibutesToBVVisit:attributes];
            
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"Visit Recorded: %@", visit.description]];
            
            if ([container.delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [container.delegate performSelector:selector withObject:visit];
#pragma clang diagnostic pop
            }
        }else{
            [_registeredDelegates removeObject:container];
        }
    }
}

-(BVVisit*)attibutesToBVVisit:(NSDictionary*)attributes {
    NSString *name = [attributes objectForKey:PLACE_NAME];
    NSString *address = [attributes objectForKey:PLACE_ADDRESS];
    NSString *city = [attributes objectForKey:PLACE_CITY];
    NSString *state = [attributes objectForKey:PLACE_STATE];
    NSString *zipCode = [attributes objectForKey:PLACE_ZIP];
    NSString *storeId = [attributes objectForKey:PLACE_STORE_ID];
    return [[BVVisit alloc]initWithName:name address:address city:city state:state zipCode:zipCode storeId:storeId];
}

#pragma mark a GMBLCommunicationManagerDelegate

- (NSArray *)communicationManager:(GMBLCommunicationManager *)manager presentLocalNotificationsForCommunications:(NSArray *)communications forVisit:(GMBLVisit *)visit {
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        return nil;
    }
    
    NSMutableArray *filteredCommunications = [NSMutableArray new];
    for ( GMBLCommunication *comm in communications) {
        NSDictionary *attributes = [self gimbalAttributesToDictionary:visit.place.attributes];
        NSString *clientId = [attributes objectForKey:PLACE_CLIENT_ID];
        if (![clientId isEqualToString:[[BVSDKManager sharedManager] clientId]]) {
            continue;
        }
        
        BVVisit *bvVisit = [self attibutesToBVVisit: attributes];
        
        if (_notificationDelegate && [_notificationDelegate shouldShowNotificationForVisit:bvVisit]) {
            [filteredCommunications addObject: comm];
        }
    }
    
    return filteredCommunications;
}

- (UILocalNotification *)communicationManager:(GMBLCommunicationManager *)manager prepareNotificationForDisplay: (UILocalNotification *)notification forCommunication:(GMBLCommunication *)communication {
    
    if (_notificationDelegate){
        return [_notificationDelegate notificationWillBePresented:notification];
    }
    
    return nil;
}

+ (void)registerForLocationUpdates:(id<BVLocationManagerDelegate>)delegate {
    
    if (!delegate){
        return;
    }
    
    if (![self getContainerForDelegate:delegate]) {
        DelegateContainer *container = [[DelegateContainer alloc]init];
        container.delegate = delegate;
        [[[self sharedManager] registeredDelegates] addObject:container];
    }
}

+ (void)unregisterForLocationUpdates:(id<BVLocationManagerDelegate>)delegate {
    DelegateContainer *container = [self getContainerForDelegate:delegate];
    if (container) {
        [[[self sharedManager] registeredDelegates]  removeObject:container];
    }
}

+(DelegateContainer *)getContainerForDelegate:(id<BVLocationManagerDelegate>)delegate {
    for ( DelegateContainer *container in [[self sharedManager] registeredDelegates] ){
        if (container.delegate == delegate) {
            return container;
        }
    }
    
    return nil;
}

+(void)setNotificationDelegate:(__weak id<BVLocationNotificationDelegate>)delegate {
    [[self sharedManager] setNotificationDelegate:delegate];
}

@end
