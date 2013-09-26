//
//  GCLoginView2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCLoginView.h"
#import <QuartzCore/QuartzCore.h>
//#import "MBProgressHUD.h"
#import "NSDictionary+QueryString.h"
#import "AFJSONRequestOperation.h"
#import "GCClient.h"
#import "GCOAuth2Client.h"

@implementation GCLoginView

@synthesize webView, oauth2Client, loginType, success, failure;

- (id)initWithFrame:(CGRect)frame inParentView:(UIView *)parentView
{
    self = [super initWithFrame:frame inParentView:parentView];
    if (self) {
        
        self.webView = [[UIWebView alloc] initWithFrame:contentView.frame];
        [self.webView setDelegate:self];
        [self.webView setScalesPageToFit:YES];
        [self.webView sizeToFit];
        [contentView addSubview:self.webView];
        
    }
    return self;
}

+ (void)showOAuth2Client:(GCOAuth2Client *)_oauth2Client withLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [self showInView:window oauth2Client:_oauth2Client withLoginType:_loginType success:_success failure:_failure];
}

+ (void)showInView:(UIView *)_view oauth2Client:(GCOAuth2Client *)_oauth2Client withLoginType:(GCLoginType)_loginType
{
        
    [self showInView:_view fromStartPoint:_view.layer.position oauth2Client:_oauth2Client withLoginType:_loginType success:nil failure:nil];
}

+ (void)showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint oauth2Client:(GCOAuth2Client *)_oauth2Client withLoginType:(GCLoginType)_loginType
{
    
    [self showInView:_view fromStartPoint:_startPoint oauth2Client:_oauth2Client withLoginType:_loginType success:nil failure:nil];

}

+ (void)showInView:(UIView *)_view oauth2Client:(GCOAuth2Client *)_oauth2Client withLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure
{
    
    [self showInView:_view fromStartPoint:_view.layer.position oauth2Client:_oauth2Client withLoginType:_loginType success:_success failure:_failure];
}

+ (void) showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint oauth2Client:(GCOAuth2Client *)_oauth2Client withLoginType:(GCLoginType)_loginType success:(void (^)(void))_success failure:(void (^)(NSError *))_failure {
    
    CGRect popupFrame = [self popupFrameForView:_view withStartPoint:_startPoint];
    
    GCLoginView *popup = [[GCLoginView alloc] initWithFrame:popupFrame inParentView:_view];
    
    popup.oauth2Client = _oauth2Client;
    popup.loginType = _loginType;
    popup.success = _success;
    popup.failure = _failure;
    
    [_view addSubview:popup];
    
    [popup showPopupWithCompletition:^{
        [popup.webView loadRequest:[popup.oauth2Client requestAccessForLoginType:_loginType]];
    }];
    
}

/*
+ (void)showInView:(UIView *)view {
    [self showInView:view fromStartPoint:view.layer.position];
}

+ (void) showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint {

    CGRect popupFrame = [self popupFrameForView:_view withStartPoint:_startPoint];
    
    GCLoginView2 *popup = [[GCLoginView2 alloc] initWithFrame:popupFrame];
    
    [_view addSubview:popup];
    
    [popup showPopup];
}
*/

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[webView setFrame:contentView.bounds];
}

#pragma mark - UIPopoverView Methods

- (void)closePopupWithCompletition:(void (^)(void))completition
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [super closePopupWithCompletition:completition];
}

#pragma mark - UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
// Gaurav's code

 if ([[[request URL] path] isEqualToString:@"/oauth/callback"]) {
        NSString *_code = [[NSDictionary dictionaryWithFormEncodedString:[[request URL] query]] objectForKey:@"code"];
    
    if (_code && [_code length] > 0) {
        [self.oauth2Client verifyAuthorizationWithAccessCode:_code success:^{
            [self closePopupWithCompletition:^{
                if (success)
                    success();
            }];
        } failure:^(NSError *error) {
            if (failure)
                failure(error);
            else
                NSAssert(!error, [error localizedDescription]);
        }];
        return NO;
    }
 }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [MBProgressHUD showHUDAddedTo:contentView animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [MBProgressHUD hideHUDForView:contentView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [MBProgressHUD hideHUDForView:contentView animated:YES];
    
    if (error.code == NSURLErrorCancelled) return;
    
    if (![[error localizedDescription] isEqualToString:@"Frame load interrupted"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reload", nil] show];
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reload"])
        [self.webView loadRequest:[self.oauth2Client requestAccessForLoginType:self.loginType]];
}


@end
