//
//  GCUIBaseViewController.m
//
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCUIBaseViewController.h"
#import "MBProgressHUD.h"
#import "GCJson.h"
#import "GCConstants.h"
#import "ASIHTTPRequest.h"
#import "GCAccount.h"

@implementation GCUIBaseViewController

- (void) setAlertCompletionBlock:(void (^)(void)) completionBlock {
    alertCompletionBlock = Block_copy(completionBlock);
}

- (void) setAlertCancelBlock:(void (^)(void)) cancelBlock {
    alertCancelBlock = Block_copy(cancelBlock);
}

- (void) showHUD {
    [self showHUDWithTitle:@"Loading..." andOpacity:0.5f];
}

- (void) showHUDWithTitle:(NSString *) title andOpacity:(CGFloat) opacity {
    HUDCount++;
    
	if (!IS_NULL(HUD))
		return;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = title;
    HUD.opacity = opacity;
	[HUD show:YES];
}

- (void) hideHUD {
	if (IS_NULL(HUD))
		return;
    
	HUDCount--;
    
	if (HUDCount > 0) {
        return;
    }
    
	[HUD hide:YES];
	[HUD removeFromSuperview];
	[HUD release], HUD=nil;
}

-(void) quickAlertWithTitle:(NSString *) title 
                    message:(NSString *) message 
                     button:(NSString *) buttonTitle {
	[self quickAlertViewWithTitle:title message:message button:buttonTitle completionBlock:^(void) {} cancelBlock:nil];
}

- (void)quickAlertViewWithTitle:(NSString *) title 
                        message:(NSString *)message 
                         button:(NSString *)button 
                completionBlock:(void (^)(void))completionBlock 
                    cancelBlock:(void (^)(void))cancelBlock {
    
    if (_alert) {
        [_alert release], _alert = nil;
    }
    
    if (cancelBlock != nil) {
        _alert = [[UIAlertView alloc] initWithTitle:title 
                                             message:message
                                            delegate:self 
                                   cancelButtonTitle:button 
                                   otherButtonTitles:@"Cancel", nil];
    }
    else {
        _alert = [[UIAlertView alloc] initWithTitle:title 
                                             message:message
                                            delegate:self 
                                   cancelButtonTitle:button 
                                   otherButtonTitles:nil];
    }
    
    
//    [_alert setBackgroundColor:[UIColor colorWithRed:50.0/255.0 green:49.0/255.0 blue:42.0/255.0 alpha:1.0] withStrokeColor:[UIColor blackColor]];
    
    [_alert show];
    
    if (completionBlock) {
        alertCompletionBlock = Block_copy(completionBlock);
    }
    
    if (cancelBlock) {
        alertCancelBlock = Block_copy(cancelBlock);
    }
    
    [_alert release], _alert = nil;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            alertCompletionBlock();
            break;
        case 1:
            alertCancelBlock();
            break;
        default:
            break;
    }
    Block_release(alertCompletionBlock);
    Block_release(alertCancelBlock);
}

- (void) viewDidDisappear:(BOOL)animated {
    if (_alert) {
        [_alert setDelegate:nil];
    }
    
    [super viewDidDisappear:YES];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

@end
