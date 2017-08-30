//
//  BVCurationsPostViewController.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@class BVCurationsAddPostRequest;
@interface BVCurationsPostViewController : SLComposeServiceViewController

-(instancetype _Nonnull) init __attribute__((unavailable("init not available")));

/**
 @param postRequest Properly initialized request. textview.text will default to postRequest.text
 @param logo Image to be presented in center of navBar. Will be proportionally scaled to fit height of navBar
 @param navBarColor desired color of navBar
 @param navBarTintColor desired tint color of navBar
 */
-(instancetype _Nonnull)initWithPostRequest:(BVCurationsAddPostRequest * _Nonnull)postRequest logoImage:(UIImage * _Nonnull)logo bavBarColor:(UIColor * _Nonnull)navBarColor navBarTintColor:(UIColor * _Nonnull)navBarTintColor;

/**
 Block used to respond to user pressing cancel button
 */
@property (nonatomic, copy, nullable) void(^didPressCancel)(void);
/**
 Block used to respond to user pressing post
 Will be called before network request is made
 Useful to display loading indicator
 */
@property (nonatomic, copy, nullable) void(^didBeginPost)(void);

/**
 Block used to respond to a network response
 Any errors that occur during request will be provided
 nil error indicates a successful post
 */
@property (nonatomic, copy, nullable) void(^didCompletePost)(NSError * _Nullable error);

@end
