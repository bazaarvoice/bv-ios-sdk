//
//  BVViewsHelper.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BVViewsHelper : NSObject

+ (void)checkButtonsInSubviews:(NSArray *)subviews
                    withTarget:(id)target
                  withSelector:(SEL)targetSelector;

+ (void)checkGestureRecognizers:(NSArray *)gestureRecognizers;

+ (NSString *)formatIndex:(NSIndexPath *)indexPath;

@end
