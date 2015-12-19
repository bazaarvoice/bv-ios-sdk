//
//  BannerDemoViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BannerDemoViewController.h"

@interface BannerDemoViewController ()

@property UIImageView* background;
@property UIButton* closeButton;
@property UIImage* closeButtonImage;

@end

@implementation BannerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerBackground.jpg"]];
    self.background.contentMode = UIViewContentModeScaleAspectFit;
    
    self.bannerView = [[BVTargetedBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"/6499/example/banner"; //Test adUnitId. Replace with your targeted adUnitId.
    self.bannerView.rootViewController = self;
    BVTargetedRequest* request = [self.bannerView getTargetedRequest];
    [self.bannerView loadRequest:request];
    
    self.closeButtonImage = [UIImage imageNamed:@"closeButton.png"];
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setImage:self.closeButtonImage forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.background];
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.closeButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.background.frame = self.view.bounds;
    
    CGSize bannerViewSize = self.bannerView.frame.size;
    self.bannerView.frame = CGRectMake((self.view.bounds.size.width - bannerViewSize.width)/2,
                                                 self.view.bounds.size.height - self.view.bounds.size.height*0.15 - bannerViewSize.height,
                                                 bannerViewSize.width,
                                                 bannerViewSize.height);
    
    self.closeButton.frame = CGRectMake(15,15,self.closeButtonImage.size.width, self.closeButtonImage.size.height);
}

-(void)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
