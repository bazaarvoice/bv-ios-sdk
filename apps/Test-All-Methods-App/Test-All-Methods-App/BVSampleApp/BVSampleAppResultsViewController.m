//
//  BVSampleAppResultsViewController.m
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import "BVSampleAppResultsViewController.h"

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
    self.urlTextView.text = self.responseToDisplay.rawURLRequest;
    self.urlResultsView.text = [self.responseToDisplay.rawResponse description];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.urlTextView.text = self.responseToDisplay.rawURLRequest;
    self.urlResultsView.text = [self.responseToDisplay.rawResponse description];
    self.title = @"BVResponse";
}

- (void)viewDidUnload
{
    [self setUrlTextView:nil];
    [self setUrlResultsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
