//
//  ViewController.m
//  iOS4
//
//  Created by Bazaarvoice Inc. on 3/15/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) didReceiveResponse:(BVResponse*)response forRequest:(BVBase *)request {
    NSLog(@"Raw Response: %@", response.rawResponse);    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     showDisplayRequest = [[BVDisplayReview alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:192612";
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    [showDisplayRequest release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
