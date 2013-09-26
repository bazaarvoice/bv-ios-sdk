//
//  BVSampleAppResultsViewController.m
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import "BVSampleAppResultsViewController.h"
#import <BVSDK/BVSDK.h>

@interface BVSampleAppResultsViewController ()

@end

@implementation BVSampleAppResultsViewController
@synthesize urlTextView;
@synthesize urlResultsView;
@synthesize responseToDisplay = _responseToDisplay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
	// Do any additional setup after loading the view.
    self.urlResultsView.text = [self.responseToDisplay description];
    if([self.requestToSend isKindOfClass:[BVPost class]]) {
        self.urlTextView.text = [(BVPost *)self.requestToSend requestURL];
    } else if([self.requestToSend isKindOfClass:[BVGet class]]) {
        self.urlTextView.text = [(BVGet *)self.requestToSend requestURL];
    } else if([self.requestToSend isKindOfClass:[BVMediaPost class]]) {
        self.urlTextView.text = [(BVMediaPost *)self.requestToSend requestURL];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"BVResponse";
}

- (void)viewDidUnload
{
    [self setUrlResultsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
