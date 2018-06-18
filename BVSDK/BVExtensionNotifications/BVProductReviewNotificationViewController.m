//
//  BVProductReviewNotificationViewController.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductReviewNotificationViewController.h"
#import "BVNotificationsAnalyticsHelper.h"

@interface BVProductReviewNotificationViewController ()

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLbl;

@end

@implementation BVProductReviewNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productNameLbl = [[UILabel alloc] init];
    _productNameLbl.translatesAutoresizingMaskIntoConstraints = NO;
    _productNameLbl.font = [UIFont systemFontOfSize:18.0];
    _productNameLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_productNameLbl];

    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productNameLbl
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeTopMargin
                                         multiplier:1.0f
                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productNameLbl
                                          attribute:NSLayoutAttributeLeft
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeLeftMargin
                                         multiplier:1
                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productNameLbl
                                          attribute:NSLayoutAttributeRight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeRightMargin
                                         multiplier:1
                                           constant:0]];
    [_productNameLbl
        addConstraint:[NSLayoutConstraint
                          constraintWithItem:_productNameLbl
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0f
                                    constant:25]];
    [_productNameLbl
        setContentCompressionResistancePriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisVertical];

    _productImageView = [[UIImageView alloc] init];
    _productImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_productImageView];

    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productNameLbl
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:_productImageView
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1
                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productImageView
                                          attribute:NSLayoutAttributeLeft
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeLeft
                                         multiplier:1.0f
                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productImageView
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_productImageView
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
    [_productImageView
        addConstraint:[NSLayoutConstraint
                          constraintWithItem:_productImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0f
                                    constant:175]];
}

- (void)didReceiveNotification:(UNNotification *)notification {
    [super didReceiveNotification:notification];

    _productNameLbl.text =
        notification.request.content.userInfo[USER_INFO_PROD_NAME];
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          NSURL *url =
              [NSURL URLWithString:notification.request.content
                                       .userInfo[USER_INFO_PROD_IMAGE_URL]];
          NSData *data = [NSData dataWithContentsOfURL:url];
          dispatch_async(dispatch_get_main_queue(), ^{
            self->_productImageView.image = [UIImage imageWithData:data];
          });
        });
}

- (ProductType)getProductType {
    return ProductTypeProduct;
}

@end
