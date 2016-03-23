//
//  RootViewController.m
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "RootViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+BVColor.h"
#import "BVAdTypesCell.h"
#import "BannerDemoViewController.h"
#import "LocationExample.h"
#import "InterstitialDemo.h"
#import "NativeContentAdDemoViewController.h"
#import "GeneralizedDemoViewController.h"


@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property InterstitialDemo* interstitialDemo;
@property LocationExample* locationListener;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ads Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // example gimbal beacon setup, used with BVAdsSDK
    // functionality not included to not include Gimbal SDK in this SDK.
    // Use GimbalExample as an example of how BVAdsSDK works with Gimbal's SDK.
    //    GimbalExample* gimbalListener = [[GimbalExample alloc] init];
    
    // example iBeacon/geofence setup, used with BVAdsSDK
    self.locationListener = [[LocationExample alloc] init];
    
    
    UIBarButtonItem* adUnitTestBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonSystemItemCamera target:self action:@selector(adUnitTestButtonPressed)];
    self.navigationItem.rightBarButtonItem = adUnitTestBarButtonItem;
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(200,140);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0,0);
    
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BVAdTypesCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell"];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interstitialError) name:@"INTERSTITIAL_ERROR" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* itemData;
    
    switch (indexPath.section) {
        case 0:
            itemData = @{
                         @"imageName": @"native.jpg",
                         @"title": @"Native Ads",
                         @"subtitle": @"Native ads blend into regular content inside your app"
                         };
            break;
        case 1:
            itemData = @{
                         @"imageName": @"interstitial.jpg",
                         @"title": @"Interstitial Ad",
                         @"subtitle": @"Interstitial ads fill up the entire screen on your customer's device"
                         };
            break;
        case 2:
            itemData = @{
                         @"imageName": @"banner.jpg",
                         @"title": @"Mobile Banner Ads",
                         @"subtitle": @"Mobile banner ads on a mobile device"
                         };
            break;
        default:
            break;
    }
    
    BVAdTypesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    cell.cellTitleLabel.text = [itemData objectForKey:@"title"];
    cell.cellDescriptionLabel.text = [itemData objectForKey:@"subtitle"];
    cell.backgroundImage.image = [UIImage imageNamed:[itemData objectForKey:@"imageName"]];
    
    return cell;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor bazaarvoiceNavy]];
    
    // set "bazaarvoice:" logo in navigationBar
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,100)];
    titleLabel.text = @"bazaarvoice";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"ForalPro-Regular" size:36];
    self.navigationItem.titleView = titleLabel;
}

-(void)adUnitTestButtonPressed {
    
    GeneralizedDemoViewController* demoViewController = [[GeneralizedDemoViewController alloc] init];
    [self.navigationController pushViewController:demoViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
                [self presentContentNativeScreen];
            }
            break;
        case 1: {
                [self requestInterstitial];
            }
            break;
        case 2: {
                [self presentBannerScreen];
            }
            break;
        default:
            break;
    }
}

-(void)requestInterstitial {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.interstitialDemo = [[InterstitialDemo alloc] initWithRootViewController:self];
    [self.interstitialDemo requestInterstitial];
}

-(void)presentContentNativeScreen {
    NativeContentAdDemoViewController* viewController = [[NativeContentAdDemoViewController alloc] initWithNibName:@"NativeContentAdDemoViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)presentBannerScreen {
    BannerDemoViewController* viewController = [[BannerDemoViewController alloc] initWithNibName:@"BannerDemoViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)interstitialError{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
