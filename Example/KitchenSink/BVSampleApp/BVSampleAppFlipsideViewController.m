//
//  BVSampleAppFlipsideViewController.m
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import "BVSampleAppFlipsideViewController.h"

@interface BVSampleAppFlipsideViewController ()

@end

@implementation BVSampleAppFlipsideViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
