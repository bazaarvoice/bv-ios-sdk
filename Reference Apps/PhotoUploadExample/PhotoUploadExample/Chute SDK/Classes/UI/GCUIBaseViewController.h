//
//  GCUIBaseViewController.h
//
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+QueryString.h"

@class MBProgressHUD;

@interface GCUIBaseViewController : UIViewController <UIAlertViewDelegate> {
    MBProgressHUD *HUD;
    NSUInteger HUDCount;
    
    UIAlertView *_alert;
    void (^alertCompletionBlock)(void);
    void (^alertCancelBlock)(void);
}

- (void) setAlertCompletionBlock:(void (^)(void)) completionBlock;
- (void) setAlertCancelBlock:(void (^)(void)) cancelBlock;

- (void) showHUD;
- (void) showHUDWithTitle:(NSString *) title andOpacity:(CGFloat) opacity;
- (void) hideHUD;
- (void) quickAlertWithTitle:(NSString *) title message:(NSString *) message button:(NSString *) buttonTitle;
- (void)quickAlertViewWithTitle:(NSString *) title message:(NSString *)message button:(NSString *)button completionBlock:(void (^)(void))completionBlock cancelBlock:(void (^)(void))cancelBlock;

@end
