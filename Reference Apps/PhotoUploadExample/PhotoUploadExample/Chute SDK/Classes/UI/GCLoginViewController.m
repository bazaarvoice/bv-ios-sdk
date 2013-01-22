//
//  LoginViewController.m
//
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCLoginViewController.h"
#import "GetChute.h"

@interface GCLoginViewController()
-(void) showAuthViewCompletion:(void (^)(void))completion;
-(void) hideAuthViewCompletion:(void (^)(void))completion;
@end


@implementation GCLoginViewController

@synthesize authView;
@synthesize authWebView;
@synthesize blankBackground;


+(void)presentInController:(UIViewController *)controller {
    [[GCAccount sharedManager] verifyAuthorizationWithAccessCode:nil success:^(void) {
    } andError:^(NSError *error) {
        GCLoginViewController *loginController = [[GCLoginViewController alloc] init];
        [controller presentModalViewController:loginController animated:YES];
        [loginController release];
    }];
}

+(void)presentAuthForService:(NSString*)service inController:(UIViewController*)controller{
    GCLoginViewController *loginController = [[GCLoginViewController alloc] init];
    [loginController setView:[loginController blankBackground]];
    [controller presentModalViewController:loginController animated:NO];
    [loginController loginWithService:service];
    [loginController release];
}

-(IBAction) login {
    [self loginWithService:[SERVICES_ARRAY objectAtIndex:kSERVICE]];
    /*
    NSDictionary *params = [NSMutableDictionary new];
    [params setValue:@"profile" forKey:@"scope"];
    [params setValue:@"web_server" forKey:@"type"];
    [params setValue:@"code" forKey:@"response_type"];
    [params setValue:kOAuthAppID forKey:@"client_id"];
    [params setValue:kOAuthCallbackURL forKey:@"redirect_uri"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/%@?%@", 
                                                                               SERVER_URL, 
                                                                               [SERVICES_ARRAY objectAtIndex:kSERVICE],
                                                                               [params stringWithFormEncodedComponents]]]];
    [authWebView sizeToFit];
    [self showAuthViewCompletion:^(void) {
        [authWebView loadRequest:request];
    }];
    [params release];
     */
}

-(void) loginWithService:(NSString*)service{
    NSDictionary *params = [NSMutableDictionary new];
    [params setValue:@"profile" forKey:@"scope"];
    [params setValue:@"web_server" forKey:@"type"];
    [params setValue:@"code" forKey:@"response_type"];
    [params setValue:kOAuthAppID forKey:@"client_id"];
    [params setValue:kOAuthCallbackURL forKey:@"redirect_uri"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/%@?%@", 
                                                                               SERVER_URL,
                                                                               service,
                                                                               [params stringWithFormEncodedComponents]]]];
    [authWebView sizeToFit];
    [self showAuthViewCompletion:^(void) {
        [authWebView loadRequest:request];
    }];
    [params release];
}

-(void) showAuthViewCompletion:(void (^)(void))completion {
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.6, 0.6);
    CGAffineTransform t2 = CGAffineTransformMakeScale(0.99, 0.99);
    CGAffineTransform t3 = CGAffineTransformMakeScale(0.85, 0.85);
    
    [authWebView setDelegate:self];
    
    [authView setCenter:self.view.center];
    [authView setTransform:t1];
    [authView setAlpha:0.0f];
    [self.view.window addSubview:authView];
    
    [UIView animateWithDuration:0.2f animations:^{
        [authView setAlpha:1.0f];
        [authView setTransform:t2]; 
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            [authView setTransform:t3]; 
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                [authView setTransform:CGAffineTransformIdentity];
                completion();
            }]; 
        }];
    }];
}

-(void) hideAuthViewCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.3f animations:^{
        [authView setAlpha:0.0f];
        [authView setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    } completion:^(BOOL finished){
        [authWebView stopLoading];
        [authWebView setDelegate:nil];
        [authView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
        completion();
    }];
}

#pragma mark WebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] path] isEqualToString:kOAuthCallbackRelativeURL]) {
        NSString *_code = [[NSDictionary dictionaryWithFormEncodedString:[[request URL] query]] objectForKey:@"code"];
        
        [[GCAccount sharedManager] verifyAuthorizationWithAccessCode:_code success:^(void) {
            [self hideAuthViewCompletion:^{
                [super dismissModalViewControllerAnimated:YES];
            }];
        } andError:^(NSError *error) {
            DLog(@"%@", [error localizedDescription]);
        }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUDWithTitle:nil andOpacity:0.3f];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHUD];
    
    if (error.code == NSURLErrorCancelled) return; 
    
    if (![[error localizedDescription] isEqualToString:@"Frame load interrupted"]) {
        [self quickAlertViewWithTitle:@"Error" message:[error localizedDescription] button:@"Reload" completionBlock:^(void) {
            [authWebView reload]; 
        } cancelBlock:^(void) {
            [self hideAuthViewCompletion:^(void) {
                
            }];
        }];
    }
}

- (void)dealloc
{
    [authView release];
    [authWebView release];
    [blankBackground release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
