//
//  BVLocationTests.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BVSDK/BVLocation.h>

@interface BVLocationManager (UnitTest)

+(id)sharedManager;
- (void)callbackToDelegates:(SEL)selector withAttributes:(NSDictionary *)attributes;

@end

@interface ReleasedDelegate : NSObject<BVLocationManagerDelegate>

@end

@implementation ReleasedDelegate

-(void)didBeginVisit:(BVVisit*)visit {
    NSAssert(false, @"This callback should not be performed");
}

-(void)didEndVisit:(BVVisit*)visit {
    NSAssert(false, @"This callback should not be performed");
}

@end


@interface BVLocationTests : XCTestCase<BVLocationManagerDelegate>

@end

@implementation BVLocationTests
{
    NSString *_clientIdKey;
    NSString *_clientId;

    BOOL _delegateCalledBack;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _clientIdKey = @"clientId";
    _clientId = @"test-classic";
    [[BVSDKManager sharedManager] setClientId:_clientId];
    [[BVSDKManager sharedManager] setStaging:YES];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testEnterOwnPlace{
    [BVLocationManager registerForLocationUpdates:self];
    
    _delegateCalledBack = NO;
    
    NSDictionary *attributes = @{_clientIdKey: _clientId, @"type": @"geofence"};
    [[BVLocationManager sharedManager] callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributes];
    
    XCTAssert(_delegateCalledBack, @"Delegate method was not performed");
}

-(void)testEnterOtherPlace{
    [BVLocationManager registerForLocationUpdates:self];
    
    _delegateCalledBack = NO;
    
    NSDictionary *attributes = @{_clientIdKey: @"otherClient", @"type": @"geofence"};
    [[BVLocationManager sharedManager] callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributes];
    
    XCTAssert(!_delegateCalledBack, @"Delegate method should not have been performed");
}

-(void)testMemoryLeak{
    ReleasedDelegate *delegate  = [[ReleasedDelegate alloc]init];
    
    [BVLocationManager registerForLocationUpdates:delegate];
    
    //BVLocationManager should not strong retain any delegates
    delegate = nil;
    NSDictionary *attributes = @{_clientIdKey: _clientId, @"type": @"geofence"};
    [[BVLocationManager sharedManager] callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributes];
}

-(void)testUnregistering {
    [BVLocationManager registerForLocationUpdates:self];
    
    _delegateCalledBack = NO;
    NSDictionary *attributes = @{_clientIdKey: _clientId, @"type": @"geofence"};
    [[BVLocationManager sharedManager] callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributes];
    //still registered should get callback
    XCTAssert(_delegateCalledBack, @"Delegate method was not performed");
    
    _delegateCalledBack = NO;
    [BVLocationManager unregisterForLocationUpdates:self];
    [[BVLocationManager sharedManager] callbackToDelegates:@selector(didBeginVisit:) withAttributes:attributes];
    //was unregistered should not get callback
    XCTAssert(!_delegateCalledBack, @"Delegate method should not have been performed");
}

-(void)didBeginVisit:(BVVisit*)visit {
    _delegateCalledBack = YES;
}

-(void)didEndVisit:(BVVisit*)visit {
}

@end
