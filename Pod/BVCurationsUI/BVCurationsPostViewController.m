//
//  BVCurationsPostViewController.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsPostViewController.h"
#import "BVCurationsAddPostRequest.h"
#import "BVCurationsPhotoUploader.h"
#import "BVCurationsAnalyticsHelper.h"
#import "UIImage+BundleLocator.h"

@interface BVCurationsPostViewController ()

@property (nonatomic, strong) BVCurationsAddPostRequest* postRequest;
@property (nonatomic, strong) UIImage * logo;
@property (nonatomic, strong) UIColor * navBarColor;
@property (nonatomic, strong) UIColor * navBarTintColor;

@end

@implementation BVCurationsPostViewController

-(instancetype _Nonnull)initWithPostRequest:(BVCurationsAddPostRequest * _Nonnull)postRequest logoImage:(UIImage * _Nonnull)logo bavBarColor:(UIColor * _Nonnull)navBarColor navBarTintColor:(UIColor * _Nonnull)navBarTintColor{
    if (self = [super init]) {
        _postRequest = postRequest;
        _logo = logo;
        _navBarColor = navBarColor;
        _navBarTintColor = navBarTintColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    self.textView.text = _postRequest.text;
    [self validateContent];
    
    [BVCurationsAnalyticsHelper queueSubmissionPageView:BVCurationsSubmissionWidgetCompose];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar {
    self.navigationController.navigationBar.tintColor = _navBarTintColor;
    
    CGFloat padding = 16;
    CGSize size = self.navigationController.navigationBar.frame.size;
    size.width -= padding * 2;
    UIImage *bkgd = [self navBarBackgroundImage:_navBarColor logo:_logo size:size];
    [self.navigationController.navigationBar setBackgroundImage:bkgd forBarMetrics:UIBarMetricsDefault];
}

- (void)didSelectCancel {
    [super didSelectCancel];
    [self dismiss];
}

- (void)didSelectPost {
    [super didSelectPost];
    _postRequest.text = self.textView.text;

    if (_didBeginPost) {
        _didBeginPost();
    }
    
    BVCurationsPhotoUploader *uploader = [[BVCurationsPhotoUploader alloc] init];
    [uploader submitCurationsContentWithParams:_postRequest completionHandler:^{
        [self completePost:nil];
    }withFailure:^(NSError * error) {
        [self completePost:error];
    }];
}

-(void)completePost:(NSError *)error {
    if (!error) {
        [BVCurationsAnalyticsHelper queueUsedFeatureUploadPhoto: BVCurationsSubmissionWidgetCompose];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (_didCompletePost) {
            _didCompletePost(error);
        }
    }];
}

-(BOOL)isContentValid {
    return self.textView.text.length && _postRequest.alias.length && _postRequest.token.length;
}

-(UIView *)loadPreviewView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [self proportionallyScaledImageOf:_postRequest.image inBoundingDimensions:imageView.frame.size];
    
    return imageView;
}

- (UIImage *)navBarBackgroundImage:(UIColor *)backgroundColor logo:(UIImage *)logo size:(CGSize)size {
    CGRect frame = CGRectZero;
    frame.size = size;
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [backgroundColor setFill];
    UIRectFill(frame);
    
    CGFloat logoPadding = 2;
    CGFloat dimension = size.height - logoPadding;
    CGSize logoSize = [self proportionalSizeOf:logo.size inBoundingSize:CGSizeMake(CGFLOAT_MAX, dimension)];
    CGRect logoFrame = CGRectMake(size.width / 2 - logoSize.width / 2, logoPadding / 2, logoSize.width, logoSize.height);
    [logo drawInRect:logoFrame];
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return backgroundImage;
}

- (NSArray *)configurationItems {
    SLComposeSheetConfigurationItem *item = [SLComposeSheetConfigurationItem new];
    item.title = @"Username";
    item.value = _postRequest.alias;
    
    return @[item];
}

- (UIImage *)proportionallyScaledImageOf:(UIImage *)image inBoundingDimensions:(CGSize)dimensions {
    CGSize imgSize = image.size;
    CGSize newSize = [self proportionalSizeOf:imgSize inBoundingSize:dimensions];

    CGImageRef cgImage = image.CGImage;
    size_t bpc = CGImageGetBitsPerComponent(cgImage);
    size_t bpr = CGImageGetBytesPerRow(cgImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
    
    CGContextRef context = CGBitmapContextCreate(nil, newSize.width, newSize.height, bpc, bpr, colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height), cgImage);
    return [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
}

-(CGSize)proportionalSizeOf:(CGSize)size inBoundingSize:(CGSize)boundingSize {
    CGFloat newW = boundingSize.width;
    CGFloat newH = newW * size.height / size.width;
    
    if (newH > boundingSize.height) {
        newH = boundingSize.height;
        newW = newH * size.width / size.height;
    }
    return CGSizeMake(newW, newH);
}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_didPressCancel) {
            _didPressCancel();
        }
    }];
}
@end
