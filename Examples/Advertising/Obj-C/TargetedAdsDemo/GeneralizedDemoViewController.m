//
//  GeneralizedDemoViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "GeneralizedDemoViewController.h"

@import GoogleMobileAds;

@interface GeneralizedDemoViewController () <
    GADInterstitialDelegate, GADNativeContentAdLoaderDelegate,
    GADNativeCustomTemplateAdLoaderDelegate, UITextFieldDelegate> {
  CGRect sharedControlsOriginalFrame;
}

// type of ad buttons
@property UISegmentedControl *adTypeControl;

// ad unit id input
@property UITextField *adUnitIdField;

// shared container with key/value pairs and the 'go' button
@property UIView *sharedControlsContainerView;

// pick between 'content' and 'custom' native ads
@property UISegmentedControl *nativeAdTypeControl;

// native custom ad template id
@property UITextField *nativeAdTypeCustomId;

// choose the banner size width and height
@property UITextField *bannerSizeWidth;
@property UITextField *bannerSizeHeight;

// custom key targeting input
@property UITextField *key1Field;
@property UITextField *key1Value;
@property UITextField *key2Field;
@property UITextField *key2Value;

// fetch ad button
@property UIButton *goButton;

// ads
@property DFPInterstitial *interstitial;
@property DFPBannerView *bannerView;
@property GADAdLoader *adLoader;

// special result container for native ads
@property UIViewController *nativeResult;

@end

@implementation GeneralizedDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];

  self.adTypeControl = [[UISegmentedControl alloc]
      initWithItems:@[ @"Interstitial", @"Banner", @"Native" ]];
  self.adTypeControl.frame =
      CGRectMake(20, 20, self.view.bounds.size.width - 40, 30);
  [self.adTypeControl addTarget:self
                         action:@selector(adTypeSwitched:)
               forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.adTypeControl];

  self.adTypeControl.selectedSegmentIndex = 0;

  sharedControlsOriginalFrame =
      CGRectMake(0, CGRectGetMaxY(self.adTypeControl.frame),
                 self.view.bounds.size.width, 200);
  self.sharedControlsContainerView =
      [[UIView alloc] initWithFrame:sharedControlsOriginalFrame];

  self.bannerSizeWidth = [[UITextField alloc]
      initWithFrame:CGRectMake(20, CGRectGetMaxY(self.adTypeControl.frame) + 20,
                               self.view.bounds.size.width / 2 - 40, 30)];
  [self.bannerSizeWidth setBorderStyle:UITextBorderStyleRoundedRect];
  [self.bannerSizeWidth setFont:[UIFont systemFontOfSize:14]];
  [self.bannerSizeWidth setPlaceholder:@"Banner width"];
  [self.bannerSizeWidth setDelegate:self];
  [self.bannerSizeWidth setReturnKeyType:UIReturnKeyDone];

  CGRect bannerHeight = self.bannerSizeWidth.frame;
  bannerHeight.origin.x += self.view.bounds.size.width / 2;
  self.bannerSizeHeight = [[UITextField alloc] initWithFrame:bannerHeight];
  [self.bannerSizeHeight setBorderStyle:UITextBorderStyleRoundedRect];
  [self.bannerSizeHeight setFont:[UIFont systemFontOfSize:14]];
  [self.bannerSizeHeight setPlaceholder:@"Banner height"];
  [self.bannerSizeHeight setDelegate:self];
  [self.bannerSizeHeight setReturnKeyType:UIReturnKeyDone];

  CGRect nativeAdTypeControlFrame = self.bannerSizeWidth.frame;
  nativeAdTypeControlFrame.size.width = self.view.bounds.size.width - 40;
  self.nativeAdTypeControl =
      [[UISegmentedControl alloc] initWithItems:@[ @"Content", @"Custom" ]];
  self.nativeAdTypeControl.frame = nativeAdTypeControlFrame;
  self.nativeAdTypeControl.selectedSegmentIndex = 0;
  [self.nativeAdTypeControl addTarget:self
                               action:@selector(nativeAdTypeSwitch:)
                     forControlEvents:UIControlEventValueChanged];
  self.nativeAdTypeCustomId = [[UITextField alloc]
      initWithFrame:CGRectMake(20, CGRectGetMaxY(nativeAdTypeControlFrame) + 10,
                               self.view.bounds.size.width - 40, 30)];
  [self.nativeAdTypeCustomId setPlaceholder:@"Custom ad template id"];
  [self.nativeAdTypeCustomId setDelegate:self];
  [self.nativeAdTypeCustomId setReturnKeyType:UIReturnKeyDone];
  [self.nativeAdTypeCustomId setBorderStyle:UITextBorderStyleRoundedRect];

  CGRect adUnitIdFrame =
      CGRectMake(20, 20, self.view.bounds.size.width - 40, 40);

  self.adUnitIdField = [[UITextField alloc] initWithFrame:adUnitIdFrame];
  [self.adUnitIdField setPlaceholder:@"Ad Unit Id"];
  [self.adUnitIdField setBorderStyle:UITextBorderStyleRoundedRect];
  [self.adUnitIdField setAdjustsFontSizeToFitWidth:true];
  [self.adUnitIdField setMinimumFontSize:4];
  [self.adUnitIdField setDelegate:self];
  [self.adUnitIdField setReturnKeyType:UIReturnKeyDone];
  [self.sharedControlsContainerView addSubview:self.adUnitIdField];

  CGRect keyValFrame =
      CGRectMake(20, CGRectGetMaxY(self.adUnitIdField.frame) + 10,
                 self.view.bounds.size.width / 2 - 40, 40);

  self.key1Field = [[UITextField alloc] initWithFrame:keyValFrame];
  [self.key1Field setPlaceholder:@"key"];
  [self.key1Field setDelegate:self];
  [self.key1Field setReturnKeyType:UIReturnKeyDone];
  [self.key1Field setBorderStyle:UITextBorderStyleRoundedRect];

  CGRect key1ValFrame = keyValFrame;
  key1ValFrame.origin.x += self.view.bounds.size.width / 2;
  self.key1Value = [[UITextField alloc] initWithFrame:key1ValFrame];
  [self.key1Value setPlaceholder:@"value"];
  [self.key1Value setDelegate:self];
  [self.key1Value setReturnKeyType:UIReturnKeyDone];
  [self.key1Value setBorderStyle:UITextBorderStyleRoundedRect];

  CGRect key2Frame = keyValFrame;
  key2Frame.origin.y += key2Frame.size.height + 10;
  self.key2Field = [[UITextField alloc] initWithFrame:key2Frame];
  [self.key2Field setPlaceholder:@"key2"];
  [self.key2Field setDelegate:self];
  [self.key2Field setReturnKeyType:UIReturnKeyDone];
  [self.key2Field setBorderStyle:UITextBorderStyleRoundedRect];

  CGRect val2Frame = key2Frame;
  val2Frame.origin.x += self.view.bounds.size.width / 2;
  self.key2Value = [[UITextField alloc] initWithFrame:val2Frame];
  [self.key2Value setPlaceholder:@"value2"];
  [self.key2Value setDelegate:self];
  [self.key2Value setReturnKeyType:UIReturnKeyDone];
  [self.key2Value setBorderStyle:UITextBorderStyleRoundedRect];

  [self.sharedControlsContainerView addSubview:self.key1Field];
  [self.sharedControlsContainerView addSubview:self.key1Value];
  [self.sharedControlsContainerView addSubview:self.key2Field];
  [self.sharedControlsContainerView addSubview:self.key2Value];

  self.goButton = [UIButton buttonWithType:UIButtonTypeSystem];
  self.goButton.frame = CGRectMake(20, CGRectGetMaxY(self.key2Field.frame) + 20,
                                   self.view.bounds.size.width - 40, 40);
  [self.goButton setTitle:@"Request Ad" forState:UIControlStateNormal];
  [self.goButton setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
  [self.goButton setTitleColor:[UIColor grayColor]
                      forState:UIControlStateSelected];

  self.goButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  self.goButton.layer.borderWidth = 0.5;
  self.goButton.layer.cornerRadius = 4;
  self.goButton.backgroundColor =
      [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
  [self.goButton addTarget:self
                    action:@selector(goPressed)
          forControlEvents:UIControlEventTouchUpInside];
  [self.sharedControlsContainerView addSubview:self.goButton];

  [self.view addSubview:self.sharedControlsContainerView];
}

- (void)adTypeSwitched:(UISegmentedControl *)sender {

  NSInteger selectedIndex = [sender selectedSegmentIndex];

  switch (selectedIndex) {
  case 0:
    [self interstitialPressed];
    break;
  case 1:
    [self bannerPressed];
    break;
  case 2:
    if (self.nativeAdTypeControl.selectedSegmentIndex == 0) {
      [self nativePressed];
    } else {
      [self nativeCustomPressed];
    }
    break;

  default:
    break;
  }
}

- (void)nativeAdTypeSwitch:(UISegmentedControl *)sender {

  NSInteger selectedIndex = sender.selectedSegmentIndex;

  switch (selectedIndex) {
  case 0:
    [self nativePressed];
    break;
  case 1:
    [self nativeCustomPressed];
    break;
  }
}

- (void)interstitialPressed {
  [self.nativeAdTypeControl removeFromSuperview];
  [self.bannerSizeHeight removeFromSuperview];
  [self.bannerSizeWidth removeFromSuperview];

  [self resetSharedControls];
}

- (void)bannerPressed {
  [self.view addSubview:self.bannerSizeHeight];
  [self.view addSubview:self.bannerSizeWidth];
  [self.nativeAdTypeControl removeFromSuperview];
  [self.nativeAdTypeCustomId removeFromSuperview];

  [self offsetSharedControls];
}

- (void)nativePressed {
  [self.view addSubview:self.nativeAdTypeControl];
  [self.nativeAdTypeCustomId removeFromSuperview];
  [self.bannerSizeHeight removeFromSuperview];
  [self.bannerSizeWidth removeFromSuperview];

  [self offsetSharedControls];
}

- (void)nativeCustomPressed {
  [self.view addSubview:self.nativeAdTypeControl];
  [self.view addSubview:self.nativeAdTypeCustomId];
  [self.bannerSizeHeight removeFromSuperview];
  [self.bannerSizeWidth removeFromSuperview];

  [self offsetSharedControlsCustom];
}

- (void)resetSharedControls {
  self.sharedControlsContainerView.frame = sharedControlsOriginalFrame;
}

- (void)offsetSharedControls {
  CGRect offsetFrame = sharedControlsOriginalFrame;
  offsetFrame.origin.y += 60;
  self.sharedControlsContainerView.frame = offsetFrame;
}

- (void)offsetSharedControlsCustom {
  CGRect offsetFrame = sharedControlsOriginalFrame;
  offsetFrame.origin.y += 90;
  self.sharedControlsContainerView.frame = offsetFrame;
}

- (void)setSelected:(bool)selected button:(UIButton *)button {
  button.backgroundColor = selected ? [UIColor colorWithRed:102.0 / 255.0
                                                      green:211.0 / 255.0
                                                       blue:3.0 / 255.0
                                                      alpha:1.0]
                                    : [UIColor whiteColor];
  [button setSelected:selected];
}

- (void)goPressed {

  [self.adUnitIdField resignFirstResponder];
  [self.bannerSizeHeight resignFirstResponder];
  [self.bannerSizeWidth resignFirstResponder];
  [self.nativeAdTypeCustomId resignFirstResponder];
  [self.key1Field resignFirstResponder];
  [self.key1Value resignFirstResponder];
  [self.key2Field resignFirstResponder];
  [self.key2Value resignFirstResponder];

  NSString *adUnitId = self.adUnitIdField.text;

  NSString *key1 = self.key1Field.text;
  NSString *val1 = self.key1Value.text;

  NSString *key2 = self.key2Field.text;
  NSString *val2 = self.key2Value.text;

  NSMutableDictionary *targeting = [NSMutableDictionary dictionary];

  if (key1 && val1 && [key1 length] > 0 && [val1 length] > 0) {
    [targeting setObject:val1 forKey:key1];
  }
  if (key2 && val2 && [key2 length] > 0 && [val2 length] > 0) {
    [targeting setObject:val2 forKey:key2];
  }

  if (self.adTypeControl.selectedSegmentIndex == 0) {
    [self requestInterstitial:adUnitId targeting:targeting];
  } else if (self.adTypeControl.selectedSegmentIndex == 1) {

    NSInteger bannerWidth = [self.bannerSizeWidth.text integerValue];
    NSInteger bannerHeight = [self.bannerSizeHeight.text integerValue];

    CGSize bannerSize = CGSizeMake(bannerWidth, bannerHeight);

    [self requestBanner:adUnitId targeting:targeting size:bannerSize];
  } else if (self.adTypeControl.selectedSegmentIndex == 2) {
    bool isCustomTemlate = self.nativeAdTypeControl.selectedSegmentIndex == 1;

    [self requestNativeAd:adUnitId
                targeting:targeting
           customTemplate:isCustomTemlate];
  }
}

#pragma mark - Interstitial ads

- (void)requestInterstitial:(NSString *)adUnitId
                  targeting:(NSDictionary *)customTargeting {

  self.interstitial = [[DFPInterstitial alloc]
      initWithAdUnitID:adUnitId]; // @"/6499/example/interstitial"
  [self.interstitial setDelegate:self];

  DFPRequest *request = [DFPRequest request];
  request.customTargeting =
      customTargeting; // override targeting for manual testing purposes
  [self.interstitial loadRequest:request];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  [self.interstitial presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad
    didFailToReceiveAdWithError:(GADRequestError *)error {

  [[[UIAlertView alloc]
          initWithTitle:@"Error"
                message:[NSString
                            stringWithFormat:@"Failed to get ad: %@", error]
               delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil] show];

  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"INTERSTITIAL_ERROR"
                    object:nil];
}

#pragma mark - Banner ads

- (void)requestBanner:(NSString *)adUnitId
            targeting:(NSDictionary *)customTargeting
                 size:(CGSize)bannerSize {
  if (self.bannerView) {
    [self.bannerView removeFromSuperview];
  }

  GADAdSize size = [self getAdSize:bannerSize];
  if (size.size.width == kGADAdSizeInvalid.size.width &&
      size.size.height == kGADAdSizeInvalid.size.height) {
    return;
  }

  self.bannerView = [[DFPBannerView alloc] initWithAdSize:size];
  self.bannerView.adUnitID = adUnitId; // @"/6499/example/banner"
  self.bannerView.rootViewController = self;
  DFPRequest *request = [DFPRequest request];
  request.customTargeting =
      customTargeting; // override targeting for manual testing purposes
  [self.bannerView loadRequest:request];

  self.bannerView.backgroundColor =
      [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
  self.bannerView.frame = CGRectMake(
      0, self.view.bounds.size.height - self.bannerView.bounds.size.height,
      self.bannerView.bounds.size.width, self.bannerView.bounds.size.height);
  [self.view addSubview:self.bannerView];
}

- (GADAdSize)getAdSize:(CGSize)size {
  if (size.width == 320 && size.height == 50) {
    return kGADAdSizeBanner;
  }
  if (size.width == 320 && size.height == 100) {
    return kGADAdSizeLargeBanner;
  }
  if (size.width == 300 && size.height == 250) {
    return kGADAdSizeMediumRectangle;
  }
  if (size.width == 468 && size.height == 60) {
    return kGADAdSizeFullBanner;
  }
  if (size.width == 728 && size.height == 90) {
    return kGADAdSizeLeaderboard;
  }

  [[[UIAlertView alloc]
          initWithTitle:@"Invalid banner size"
                message:@"invalid banner ad size (for this demo app)."
               delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil] show];

  return kGADAdSizeInvalid;
}

#pragma mark - Native ads

- (void)requestNativeAd:(NSString *)adUnitId
              targeting:(NSDictionary *)customTargeting
         customTemplate:(bool)custom {

  NSArray *adTypes = @[ custom ? kGADAdLoaderAdTypeNativeCustomTemplate
                               : kGADAdLoaderAdTypeNativeContent ];

  self.adLoader =
      [[GADAdLoader alloc] initWithAdUnitID:adUnitId // @"/6499/example/native"
                         rootViewController:self
                                    adTypes:adTypes
                                    options:nil];

  [self.adLoader setDelegate:self];
  DFPRequest *request = [DFPRequest request];
  request.customTargeting =
      customTargeting; // override targeting for manual testing purposes
  [self.adLoader loadRequest:request];
}

- (void)adLoader:(GADAdLoader *)adLoader
    didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {

  if (self.nativeResult) {
    [self.nativeResult removeFromParentViewController];
  }

  self.nativeResult = [[UIViewController alloc] init];
  self.nativeResult.view.frame = self.view.bounds;
  UIView *overlay =
      [[UIView alloc] initWithFrame:self.nativeResult.view.bounds];
  overlay.backgroundColor = [UIColor blackColor];
  overlay.alpha = 0.8;
  [self.nativeResult.view addSubview:overlay];

  GADNativeContentAdView *contentAdView =
      [[[NSBundle mainBundle] loadNibNamed:@"NativeContentAdView"
                                     owner:nil
                                   options:nil] firstObject];

  // Associate the app install ad view with the app install ad object.
  // This is required to make the ad clickable.
  contentAdView.nativeContentAd = nativeContentAd;

  // Populate the app install ad view with the app install ad assets.
  ((UIImageView *)contentAdView.logoView).image = nativeContentAd.logo.image;
  ((UIImageView *)contentAdView.imageView).image =
      ((GADNativeAdImage *)[nativeContentAd.images firstObject]).image;
  ((UILabel *)contentAdView.headlineView).text = nativeContentAd.headline;
  ((UILabel *)contentAdView.advertiserView).text = nativeContentAd.advertiser;
  ((UILabel *)contentAdView.bodyView).text = nativeContentAd.body;
  [((UIButton *)contentAdView.callToActionView)
      setTitle:nativeContentAd.callToAction
      forState:UIControlStateNormal];

  // In order for the SDK to process touch events properly, user interaction
  // should be disabled on UIButtons. Must be disabled in nib -- just
  // highlighted here for completeness.
  contentAdView.callToActionView.userInteractionEnabled = NO;

  // size appropriately
  CGFloat padding = self.view.bounds.size.width * 0.1;
  contentAdView.frame = CGRectMake(padding, self.view.bounds.size.height * 0.2,
                                   self.view.bounds.size.width - padding * 2,
                                   self.view.bounds.size.height * 0.6);

  // add a border and shadow, just to highlight in this demo application
  contentAdView.layer.borderColor = [[UIColor grayColor] CGColor];
  contentAdView.layer.borderWidth = 0.5;
  contentAdView.layer.cornerRadius = 2;
  contentAdView.layer.shadowColor = [[UIColor grayColor] CGColor];
  contentAdView.layer.shadowOffset = CGSizeMake(0, 5);
  contentAdView.layer.shadowRadius = 5;
  contentAdView.layer.shadowOpacity = 0.6;
  contentAdView.layer.masksToBounds = NO;

  UIImage *closeButtonImage = [UIImage imageNamed:@"closeButton.png"];
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
  [closeButton addTarget:self
                  action:@selector(nativeCloseButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
  closeButton.frame = CGRectMake(0, 0, closeButtonImage.size.width,
                                 closeButtonImage.size.height);
  [self.nativeResult.view addSubview:closeButton];

  [self.nativeResult.view addSubview:contentAdView];

  [self.view addSubview:self.nativeResult.view];
  [self addChildViewController:self.nativeResult];
  [self.nativeResult didMoveToParentViewController:self];
}

- (void)nativeCloseButtonPressed {
  [self.nativeResult willMoveToParentViewController:nil];
  [self.nativeResult removeFromParentViewController];
  [self.nativeResult.view removeFromSuperview];
}

- (void)adLoader:(GADAdLoader *)adLoader
    didFailToReceiveAdWithError:(GADRequestError *)error {

  [[[UIAlertView alloc]
          initWithTitle:@"Error"
                message:[NSString
                            stringWithFormat:@"Failed to get ad: %@", error]
               delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil] show];
}

- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
  NSString *customTemplateId = self.nativeAdTypeCustomId.text;
  NSLog(@"native custom template: %@", customTemplateId);
  return @[ customTemplateId ];
}

/// Tells the delegate that a native custom template ad was received.
- (void)adLoader:(GADAdLoader *)adLoader
    didReceiveNativeCustomTemplateAd:
        (GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
  NSLog(@"Got a custom native ad! %@", nativeCustomTemplateAd);

  if (self.nativeResult) {
    [self.nativeResult removeFromParentViewController];
  }

  self.nativeResult = [[UIViewController alloc] init];
  self.nativeResult.view.frame = self.view.bounds;
  UIView *overlay =
      [[UIView alloc] initWithFrame:self.nativeResult.view.bounds];
  overlay.backgroundColor = [UIColor blackColor];
  overlay.alpha = 0.8;
  [self.nativeResult.view addSubview:overlay];

  CGRect contentView = CGRectInset(self.nativeResult.view.bounds, 30, 50);
  UIView *content = [[UIView alloc] initWithFrame:contentView];
  content.layer.cornerRadius = 3;
  content.backgroundColor = [UIColor whiteColor];

  int labelY = 0;
  int labelWidth = contentView.size.width;
  int labelHeight = 30;
  for (NSString *assetKey in nativeCustomTemplateAd.availableAssetKeys) {
    NSString *str = [nativeCustomTemplateAd stringForKey:assetKey];
    if (str) {
      UILabel *label = [[UILabel alloc]
          initWithFrame:CGRectMake(0, labelY, labelWidth, labelHeight)];
      label.text = str;
      label.font = [UIFont systemFontOfSize:10];
      label.textColor = [UIColor blackColor];
      [content addSubview:label];
      labelY += labelHeight;
    }
  }

  int imgY = labelY;
  int imgWidth = 60;
  int imgHeight = 60;

  for (NSString *assetKey in nativeCustomTemplateAd.availableAssetKeys) {
    GADNativeAdImage *adImage = [nativeCustomTemplateAd imageForKey:assetKey];
    if (adImage) {
      UIImageView *img = [[UIImageView alloc] initWithImage:adImage.image];
      img.frame = CGRectMake(0, imgY, imgWidth, imgHeight);
      [content addSubview:img];
      imgY += imgHeight;
    }
  }

  UIImage *closeButtonImage = [UIImage imageNamed:@"closeButton.png"];
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
  [closeButton addTarget:self
                  action:@selector(nativeCloseButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
  closeButton.frame = CGRectMake(0, 0, closeButtonImage.size.width,
                                 closeButtonImage.size.height);
  [self.nativeResult.view addSubview:closeButton];

  [self.nativeResult.view addSubview:content];

  [self.view addSubview:self.nativeResult.view];
  [self addChildViewController:self.nativeResult];
  [self.nativeResult didMoveToParentViewController:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

@end
