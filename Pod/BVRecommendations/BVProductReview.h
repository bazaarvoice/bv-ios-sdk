//
//  BVProductReview.h
//  Pods
//
//  Created by Bazaarvoice on 1/11/16.
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


#import <Foundation/Foundation.h>

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }

@interface BVProductReview : NSObject

-(id)initWithDict:(NSDictionary*)dict;

/**
 *  Title the customer gave on the review of this product.
 */
@property (strong, nonatomic) NSString *reviewTitle;

/**
 *  Highlighted review for this product
 */
@property (strong, nonatomic) NSString *reviewText;

/**
 *  The author's name for the review highlight
 */
@property (strong, nonatomic) NSString *reviewAuthorName;

@end
