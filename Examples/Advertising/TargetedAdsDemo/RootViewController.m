//
//  RootViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "RootViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NativeDemoViewController.h"
#import "UIColor+BVColor.h"
#import "BVAdTypesCell.h"
#import "UILabelWithInset.h"
#import "BannerDemoViewController.h"
#import "LocationExample.h"
#import "InterstitialDemo.h"
#import "GeneralizedDemoViewController.h"

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property UIImage* happyGuyBaseImage;
@property UIImageView* happyGuy;
@property UILabel* mobileAdTypesLabel;
@property UILabelWithInset* descriptionLabel;

@property UICollectionView* collectionView;
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
    
    
    self.happyGuyBaseImage = [UIImage imageNamed:@"happyguy.jpg"];
    self.happyGuy = [[UIImageView alloc] initWithImage:self.happyGuyBaseImage];
    self.happyGuy.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.happyGuy];
    
    self.mobileAdTypesLabel = [[UILabel alloc] init];
    self.mobileAdTypesLabel.text = @"Mobile Ad Types";
    self.mobileAdTypesLabel.textColor = [UIColor bazaarvoiceNavy];
    self.mobileAdTypesLabel.numberOfLines = 0;
    self.mobileAdTypesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.mobileAdTypesLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.width / 15];
    self.mobileAdTypesLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mobileAdTypesLabel];
    
    self.descriptionLabel = [[UILabelWithInset alloc] initWithInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.descriptionLabel.text = @"Bazaarvoice offers a wide range of mobile ad types to target your consumers across the Bazaarvoice network.";
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    self.descriptionLabel.numberOfLines = 3;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.width / 26];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.descriptionLabel];
    
    UIBarButtonItem* adUnitTestBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStyleDone target:self action:@selector(adUnitTestButtonPressed)];
    self.navigationItem.rightBarButtonItem = adUnitTestBarButtonItem;
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(200,140);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0,0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[BVAdTypesCell class] forCellWithReuseIdentifier:@"cvCell"];
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
                         @"imageName": @"interstitial.jpg",
                         @"title": @"Interstitial Ad",
                         @"subtitle": @"Interstitial ads fill up the entire screen on your customer's device"
                         };
            break;
        case 1:
            itemData = @{
                         @"imageName": @"banner.jpg",
                         @"title": @"Mobile Banner Ads",
                         @"subtitle": @"Mobile banner ads on a mobile device"
                         };
            break;
        case 2:
            itemData = @{
                         @"imageName": @"native.jpg",
                         @"title": @"Native Ads",
                         @"subtitle": @"Native ads blend into regular content inside your app"
                         };
            break;
        default:
            break;
    }
    
    
    static NSString *cellIdentifier = @"cvCell";
    
    BVAdTypesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = [itemData objectForKey:@"title"];
    cell.descriptionLabel.text = [itemData objectForKey:@"subtitle"];
    cell.imageView.image = [UIImage imageNamed:[itemData objectForKey:@"imageName"]];
    
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
    
    CGFloat ratio = self.view.bounds.size.width / self.happyGuyBaseImage.size.width;
    CGFloat adjustedHeight = self.happyGuyBaseImage.size.height*ratio;
    self.happyGuy.frame = CGRectMake(0,
                                     0,
                                     self.view.bounds.size.width,
                                     adjustedHeight);
    
    self.mobileAdTypesLabel.frame = CGRectMake(0,
                                               CGRectGetMaxY(self.happyGuy.frame) + self.view.bounds.size.height * 0.02,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height * 0.06);
    
    self.descriptionLabel.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.mobileAdTypesLabel.frame),
                                             self.view.bounds.size.width,
                                             self.view.bounds.size.height * 0.12);
    
    self.collectionView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.descriptionLabel.frame)+20,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - CGRectGetMaxY(self.descriptionLabel.frame) - 20*2);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    NSLog(@"Test ad unit id!!!!");
//    [self adUnitTestButtonPressed];
}

-(void)adUnitTestButtonPressed {
    
    GeneralizedDemoViewController* demoViewController = [[GeneralizedDemoViewController alloc] init];
    [self.navigationController pushViewController:demoViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            [self requestInterstitial];
        }
            break;
        case 1:
        {
            [self presentBannerScreen];
        }
            break;
        case 2:
        {
            [self presentNativeScreen];
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

-(void)presentNativeScreen {
    NativeDemoViewController* viewController = [[NativeDemoViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)presentBannerScreen {
    BannerDemoViewController* viewController = [[BannerDemoViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)interstitialError{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
