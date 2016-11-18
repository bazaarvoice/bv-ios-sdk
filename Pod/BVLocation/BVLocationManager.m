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
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSMutableArray *registeredDelegates;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveLocationAPIKey:)
                                                     name:LOCATION_API_KEY_SET_NOTIFICATION
                                                   object:nil];

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
    }else {
        NSAssert(NO, @"You must provide a valid Location API Key before using BVLocation");
    }
}

- (void) receiveLocationAPIKey:(NSNotification *) notification
{
    // [notification name] should always be LOCATION_API_KEY_SET_NOTIFICATION
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:LOCATION_API_KEY_SET_NOTIFICATION]){
        
        [[BVLogger sharedLogger] verbose:@"Recieved notifcation for location configuration"];
        
        _apiKey = [notification.userInfo valueForKeyPath:LOCATION_API_KEY_SET_NOTIFICATION];
        [self initGimbal];
        
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
    
    NSDictionary *attributeDictionary = [self gimbalVisitToDictionary:visit];
    
    if ([self gimbalPlaceIsValid:visit.place]) {
        [BVLocationAnalyticsHelper queueAnalyticsEventForGimbalVisit:visit];
    }
    
    [self callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributeDictionary];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit {
    
    NSDictionary *attributeDictionary = [self gimbalVisitToDictionary:visit];
    
    if ([self gimbalPlaceIsValid:visit.place]) {
        [BVLocationAnalyticsHelper queueAnalyticsEventForGimbalVisit:visit];
    }
    
    [self callbackToDelegates:@selector(didEndVisit:) withAttributes:attributeDictionary];
}

-(BOOL)gimbalPlaceIsValid:(GMBLPlace*)place {
    return [place.attributes stringForKey:@"id"] != nil;
}

-(NSDictionary*)gimbalVisitToDictionary:(GMBLVisit *)visit {
    
    GMBLAttributes *attributes = visit.place.attributes;
    
    NSMutableDictionary *attributeDictionary = [NSMutableDictionary new];
    
    for (NSString *key in attributes.allKeys) {
        [attributeDictionary setObject:[attributes stringForKey:key] forKey:key];
    }
    
    if (visit.arrivalDate){
        [attributeDictionary setObject:visit.arrivalDate forKey:ARRIVAL_DATE];
    }
    
    if (visit.departureDate){
        [attributeDictionary setObject:visit.departureDate forKey:DEPARTURE_DATE];
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
    NSDate *arrivalDate = [attributes objectForKey:ARRIVAL_DATE];
    NSDate *departureDate = [attributes objectForKey:DEPARTURE_DATE];
    
    return [[BVVisit alloc] initWithName:name
                                 address:address
                                    city:city
                                   state:state
                                 zipCode:zipCode
                                 storeId:storeId
                             arrivalDate:arrivalDate
                           departureDate:departureDate];
    
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

@end
