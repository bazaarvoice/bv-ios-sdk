//
//  ViewController.h
//  iOS4
//
//  Created by Bazaarvoice Inc. on 3/15/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVIncludes.h"

@interface ViewController : UIViewController <BVDelegate> {
    BVDisplayReview *showDisplayRequest;
}

@end
