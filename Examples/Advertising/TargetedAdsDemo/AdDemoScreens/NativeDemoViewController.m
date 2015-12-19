//
//  NativeDemoViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "NativeDemoViewController.h"
#import "MyContentAdView.h"
#import "BVAdTypesCell.h"
#import "BVProductsViewCell.h"

@interface NativeDemoViewController()<GADNativeContentAdLoaderDelegate>

@property UIImageView* background;
@property UIImage* closeButtonImage;
@property UIButton* closeButton;
@property GADNativeContentAd* nativeContentAd;
@property UILabel* recommendedProductLabel;

@end

@implementation NativeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Native";
    self.view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1.0];
    
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nativeBackground.jpg"]];
    self.background.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.background];
    
    self.recommendedProductLabel = [[UILabel alloc] init];
    self.recommendedProductLabel.text = @"Recommended Products";
    self.recommendedProductLabel.textColor = [UIColor blackColor];
    self.recommendedProductLabel.numberOfLines = 1;
    self.recommendedProductLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.width * 0.05];
    
    self.closeButtonImage = [UIImage imageNamed:@"closeButton.png"];
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setImage:self.closeButtonImage forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.closeButton];
    
    [self setupNativeAd];
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = [self getItemSize];
    layout.sectionInset = UIEdgeInsetsMake(0,10,0,0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView registerClass:[BVProductsViewCell class] forCellWithReuseIdentifier:@"productsCell"];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.recommendedProductLabel];
}

-(CGSize)getItemSize {
    return CGSizeMake(self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.45);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.background.frame = self.view.bounds;

    self.closeButton.frame = CGRectMake(15,
                                        15,
                                        self.closeButtonImage.size.width,
                                        self.closeButtonImage.size.height);
    
    self.recommendedProductLabel.frame = CGRectMake(14,
                                                    self.view.bounds.size.height * 0.125,
                                                    self.view.bounds.size.width,
                                                    20);
    
    self.collectionView.frame = CGRectMake(0,
                                           self.view.bounds.size.height * 0.15,
                                           self.view.bounds.size.width,
                                           [self getItemSize].height);
}

-(void)setupNativeAd {
    //Test adUnitId. Replace with your targeted adUnitId.
    self.adLoader = [[BVTargetedAdLoader alloc]
                         initWithAdUnitID:@"/6499/example/native"
                         rootViewController:self
                         adTypes:@[ kGADAdLoaderAdTypeNativeContent ]  /* possibly any combination of : kGADAdLoaderAdTypeNativeContent, kGADAdLoaderAdTypeNativeCustomTemplate, kGADAdLoaderAdTypeNativeAppInstall */
                         options:nil];
    
    [self.adLoader setDelegate:self];
    BVTargetedRequest* request = [self.adLoader getTargetedRequest];
    [self.adLoader loadRequest:request];
}

#pragma mark - GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {

    self.nativeContentAd = nativeContentAd;
    [self.collectionView reloadData];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[NSString stringWithFormat:@"Failed to get ad: %@", error]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)closeButtonPressed {

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray* itemData = @[@{
                               @"imageName": @"polo.jpg",
                               @"headline": @"St. John's Bay Short-Sleeve Pique Knit Polo Shirt",
                               @"price": @"$18",
                               @"stars": @(4.5),
                               @"ratings": @"(166)",
                               @"adView": [NSNumber numberWithBool:false]
                           },
                          @{
                               @"imageName": @"",
                               @"headline": @"",
                               @"price": @"",
                               @"stars": @(0),
                               @"ratings": @"",
                               @"adView": [NSNumber numberWithBool:true]
                           },
                          @{
                               @"imageName": @"basket.png",
                               @"headline": @"Wire and Canvas Storage Basket",
                               @"price": @"$29",
                               @"stars": @(4.5),
                               @"ratings": @"63",
                               @"adView": [NSNumber numberWithBool:false]
                           }];
    
    NSDictionary* item = (NSDictionary*)[itemData objectAtIndex:indexPath.row];
    
    BVProductsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productsCell" forIndexPath:indexPath];
    
    CGSize cellSize = cell.bounds.size;
    MyContentAdView* adView = [[MyContentAdView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
    
    if([[item objectForKey:@"adView"] boolValue] == true){

        if(self.nativeContentAd != nil){
            [adView setNativeContentAd:self.nativeContentAd];
            [adView setIsSponsored:YES];
        }
        else {
            return cell;
        }
    }
    else {

        adView.headline = [item objectForKey:@"headline"];
        adView.price = [item objectForKey:@"price"];
        adView.stars = [item objectForKey:@"stars"];
        adView.ratings = [item objectForKey:@"ratings"];
        adView.productImage = [UIImage imageNamed:[item objectForKey:@"imageName"]];
        adView.isSponsored = false;
    }
    
    [cell addSubview:adView];
    
    return cell;
}


@end