//
//  TestBase.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef TestBase_h
#define TestBase_h

#include <FBSnapshotTestCase/FBSnapshotTestCase.h>
#include <BVSDK/BVRecommendations.h>
#include <BVSDK/BVRecommendationsUI.h>

@interface TestBase : FBSnapshotTestCase

@property CGRect iphone_5, iphone_6, iphone_6plus, ipad;

@property BVProduct* testProduct;
@property XCTestExpectation* expectation;

-(void)waitAndCheck:(UIView*)view;
-(void)checkViews:(UIView*)view;

@end

#endif /* TestBase_h */
