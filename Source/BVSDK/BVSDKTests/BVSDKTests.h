//
//  BVSDKTests.h
//  BVSDKTests
//
//  Created by Bazaarvoice Engineering on 11/26/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BVDelegate.h"

@interface BVSDKTests : SenTestCase<BVDelegate> {
    BOOL requestComplete;
    BOOL receivedProgressCallback;
    id sentRequest;
    NSDictionary * receivedResponse;
}


@end
