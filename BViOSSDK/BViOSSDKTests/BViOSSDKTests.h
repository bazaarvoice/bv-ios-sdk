//
//  BViOSSDKTests.h
//  BViOSSDKTests
//
//  Created by Bazaarvoice Engineering on 3/13/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVIncludes.h"
#import <SenTestingKit/SenTestingKit.h>

@interface BViOSSDKTests : SenTestCase <BVDelegate> {
    BOOL requestComplete;
    BOOL receivedProgressCallback;
    BVResponse *receivedResponse;
    BVBase *sentRequest;
}

@end
