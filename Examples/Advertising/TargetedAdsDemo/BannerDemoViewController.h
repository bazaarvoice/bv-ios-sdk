//
//  BannerDemoViewController.h
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface BannerDemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* closeButton;
@property (weak, nonatomic) IBOutlet DFPBannerView* bannerView;

@end
