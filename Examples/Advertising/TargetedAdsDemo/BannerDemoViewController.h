//
//  BannerDemoViewController.h
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BVSDK/BVAdvertising.h>

@interface BannerDemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* closeButton;
@property (weak, nonatomic) IBOutlet BVTargetedBannerView* bannerView;

@end
