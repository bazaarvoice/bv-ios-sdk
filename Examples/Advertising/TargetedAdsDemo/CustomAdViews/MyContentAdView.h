//
//  MyContentAdView.h
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

@import GoogleMobileAds;

@interface MyContentAdView : GADNativeContentAdView

@property NSString* headline;
@property NSString* price;
@property NSNumber* stars;
@property NSString* ratings;
@property UIImage* productImage;
@property BOOL isSponsored;

@property UILabel* priceLabel;
@property UILabel* headlineLabel;
@property UILabel* starsLabel;
@property UILabel* ratingsLabel;
@property UILabel* sponsoredLabel;
@property UIImageView* productImageView;

@end