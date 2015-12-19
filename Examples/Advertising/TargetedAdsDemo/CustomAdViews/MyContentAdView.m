//
//  MyContentAdView.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "MyContentAdView.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

@interface MyContentAdView()

@property GADNativeContentAd* localNativeContentAd;

@end

@implementation MyContentAdView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.headlineLabel = [[UILabel alloc] init];
        self.headlineLabel.text = @"Headline";
        self.headlineLabel.textColor = [UIColor blackColor];
        self.headlineLabel.numberOfLines = 0;
        self.headlineLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.headlineLabel.font = [UIFont systemFontOfSize:self.bounds.size.height / 18];
        self.headlineLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.headlineLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.text = @"Price";
        self.priceLabel.textColor = [UIColor blackColor];
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.font = [UIFont systemFontOfSize:self.bounds.size.height / 20];
        [self addSubview:self.priceLabel];
        
        self.starsLabel = [[UILabel alloc] init];
        self.starsLabel.text = @"Stars";
        self.starsLabel.textColor = [UIColor blackColor];
        self.starsLabel.numberOfLines = 1;
        [self addSubview:self.starsLabel];
        
        self.ratingsLabel = [[UILabel alloc] init];
        self.ratingsLabel.text = @"Ratings";
        self.ratingsLabel.textColor = [UIColor blackColor];
        self.ratingsLabel.numberOfLines = 1;
        self.ratingsLabel.font = [UIFont systemFontOfSize:self.bounds.size.height / 24];
        self.ratingsLabel.textColor = [UIColor blueColor];
        [self addSubview:self.ratingsLabel];
        
        self.sponsoredLabel = [[UILabel alloc] init];
        self.sponsoredLabel.text = @"Sponsored ⓘ";
        self.sponsoredLabel.textColor = [UIColor grayColor];
        self.sponsoredLabel.numberOfLines = 1;
        self.sponsoredLabel.font = [UIFont systemFontOfSize:self.bounds.size.height / 26];
        self.sponsoredLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.sponsoredLabel];
        
        self.productImageView = [[UIImageView alloc] init];
        self.productImageView.contentMode = UIViewContentModeScaleToFill;
        self.productImageView.layer.borderWidth = 0.5;
        self.productImageView.layer.borderColor = [[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0] CGColor];
        [self addSubview:self.productImageView];
    }
    return self;
}


- (void)setNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    
    // Maps the GADNativeAppInstallAdView properties to the individual asset views.
    self.headlineLabel = self.headlineLabel;
    self.priceLabel = self.priceLabel;
    self.productImageView = self.productImageView;
    self.ratingsLabel = self.ratingsLabel;
    
    // Populate values from nativeContentAd into views
    self.headline = nativeContentAd.headline;
    self.price = nativeContentAd.body;
    self.ratings = [NSString stringWithFormat:@"(%@)", nativeContentAd.callToAction];
    self.stars = @(4.5);
    self.productImage = (UIImage *)[[nativeContentAd.images firstObject] image];
    
    [self setNeedsLayout];

    // Set the native ad on the ad view class.
    [super setNativeContentAd:nativeContentAd];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.sponsoredLabel.frame = CGRectMake(0,
                                           0,
                                           self.bounds.size.width,
                                           20);
    
    self.productImageView.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.sponsoredLabel.frame),
                                             self.bounds.size.width,
                                             self.bounds.size.height/2);
    
    self.headlineLabel.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.productImageView.frame) + 5,
                                          self.bounds.size.width,
                                          self.bounds.size.height * 0.2);
    
    self.priceLabel.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.headlineLabel.frame) + 5,
                                       self.bounds.size.width,
                                       24);
    
    self.starsLabel.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.priceLabel.frame),
                                       self.bounds.size.width,
                                       16);
    
    CGSize sizeThatFits = [self.starsLabel sizeThatFits:self.bounds.size];
    self.ratingsLabel.frame = CGRectMake(sizeThatFits.width + 8,
                                         CGRectGetMinY(self.starsLabel.frame) - 4,
                                         self.bounds.size.width - sizeThatFits.width,
                                         sizeThatFits.height);
    
    self.headlineLabel.text = self.headline;
    self.ratingsLabel.text = self.ratings;
    self.priceLabel.text = self.price;
    self.starsLabel.attributedText = [self getStarsString];
    self.productImageView.image = self.productImage;
    self.sponsoredLabel.text = self.isSponsored ? @"Sponsored ⓘ" : @"";
}

-(NSAttributedString*)getStarsString {
    
    NSMutableAttributedString* starsString = [[NSMutableAttributedString alloc] init];
    
    float starsValue = [self.stars floatValue];
    for(int i=0; i<floorf(starsValue); i++){
        [starsString appendAttributedString:[self getFullStar]];
    }
    
    if(ceilf(starsValue) != floorf(starsValue)){ //half star
        [starsString appendAttributedString:[self getHalfStar]];
    }
    
    return starsString;
}

-(NSAttributedString*)getFullStar {
    FAKFontAwesome *starsIcon = [FAKFontAwesome starIconWithSize:10];
    [starsIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
    return [starsIcon attributedString];
}

-(NSAttributedString*)getHalfStar {
    FAKFontAwesome *starsIcon = [FAKFontAwesome starHalfEmptyIconWithSize:10];
    [starsIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
    return [starsIcon attributedString];
}

@end
