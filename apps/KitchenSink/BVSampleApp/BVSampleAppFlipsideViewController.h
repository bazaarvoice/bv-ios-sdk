//
//  BVSampleAppFlipsideViewController.h
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BVSampleAppFlipsideViewController;

@protocol BVSampleAppFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(BVSampleAppFlipsideViewController *)controller;
@end

@interface BVSampleAppFlipsideViewController : UIViewController

@property (weak, nonatomic) id <BVSampleAppFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
