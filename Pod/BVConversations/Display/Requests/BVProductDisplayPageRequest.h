//
//  ProductDisplayPageRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDPContentType.h"
#import "BVBaseProductRequest.h"

typedef void (^ProductRequestCompletionHandler)(BVProductsResponse* _Nonnull response);

/*
 You can retrieve all information needed for a Product Display Page with this request.
 Optionally, you can include `Reviews` or `QuestionsAndAnswers` as well as statistics on 
 reviews and questions and answers.
 Optionally, you can filter and sort the questions using the `addSort*` and `addFilter*` methods.
 */
@interface BVProductDisplayPageRequest : BVBaseSortableProductRequest


/// Initialize the request for the product ID you are displaying on your product page.
- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId;
- (nonnull instancetype) __unavailable init;

- (void)load:(ProductRequestCompletionHandler _Nonnull)success failure:(ConversationsFailureHandler _Nonnull)failure;

@end
