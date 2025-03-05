//
//  BVPixelTypes.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The types of user-interaction events that can be fired.
 */
typedef NS_ENUM(NSInteger, BVPixelFeatureUsedEventName) {
  BVPixelFeatureUsedEventNameWriteReview,
  BVPixelFeatureUsedEventNameAskQuestion,
  BVPixelFeatureUsedEventNameAnswerQuestion,
  BVPixelFeatureUsedEventNameReviewComment,
  BVPixelFeatureUsedEventNameFeedback,
  BVPixelFeatureUsedEventNameInappropriate,
  BVPixelFeatureUsedEventNamePhoto,
  BVPixelFeatureUsedEventNameScrolled,
  BVPixelFeatureUsedEventContentClick,
  BVPixelFeatureUsedEventNameInView,
  BVPixelFeatureUsedNameProfile,
  BVPixelFeatureUsedEventNameReviewHighlights,
  BVPixelFeatureUsedEventNameReviewSummary
};

@interface BVPixelFeatureUsedEventNameUtil : NSObject

+ (NSString *)toString:(BVPixelFeatureUsedEventName)Featuretype;

@end

/**
 The UGC content types individual impressions.
 */
typedef NS_ENUM(NSInteger, BVPixelImpressionContentType) {
  BVPixelImpressionContentTypeReview,
  BVPixelImpressionContentTypeQuestion,
  BVPixelImpressionContentTypeAnswer,
  BVPixelImpressionContentTypeComment,
  BVPixelImpressionContentProductRecommendation,
  BVPixelImpressionContentCurationsFeedItem
};

@interface BVPixelImpressionContentTypeUtil : NSObject

+ (NSString *)toString:(BVPixelImpressionContentType)contentType;

@end

/**
 Types of Bazaarvoice products supported in this SDK.
 */
typedef NS_ENUM(NSInteger, BVPixelProductType) {
  BVPixelProductTypeConversationsReviews,
  BVPixelProductTypeConversationsQuestionAnswer,
  BVPixelProductTypeConversationsProfile,
  BVPixelProductTypeCurations,
  BVPixelProductTypeProductRecommendations,
  BVPixelProductTypePIN,
  BVPixelProductTypeLocation,
  BVPixelProductTypeProgressiveSubmission,
  BVPixelProductTypeProductSentiments
};

@interface BVPixelProductTypeUtil : NSObject

+ (NSString *)toString:(BVPixelProductType)type;

@end
