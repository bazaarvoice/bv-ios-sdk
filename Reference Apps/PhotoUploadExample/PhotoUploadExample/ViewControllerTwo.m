//
//  ViewControllerTwo.m
//  PhotoUploadExample
//
//  Created by Alex Medearis on 4/18/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "ViewControllerTwo.h"

@interface ViewControllerTwo ()

@end

@implementation ViewControllerTwo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
