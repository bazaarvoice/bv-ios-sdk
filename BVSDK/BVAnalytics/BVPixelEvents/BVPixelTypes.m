//
//  BVPixelTypes.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVPixelTypes.h"

@implementation BVPixelFeatureUsedEventNameUtil

+ (NSString *)toString:(BVPixelFeatureUsedEventName)featuretype {
  switch (featuretype) {
  case BVPixelFeatureUsedEventNameWriteReview:
    return @"Write";
  case BVPixelFeatureUsedEventNameAskQuestion:
    return @"Question";
  case BVPixelFeatureUsedEventNameAnswerQuestion:
    return @"Answer";
  case BVPixelFeatureUsedEventNameReviewComment:
    return @"Comment";
  case BVPixelFeatureUsedEventNameFeedback:
    return @"Helpfulness";
  case BVPixelFeatureUsedEventNameInappropriate:
    return @"Inappropriate";
  case BVPixelFeatureUsedEventNamePhoto:
    return @"Photo";
  case BVPixelFeatureUsedEventNameInView:
    return @"InView";
  case BVPixelFeatureUsedEventNameScrolled:
    return @"Scrolled";
  case BVPixelFeatureUsedEventContentClick:
    return @"Click";
  case BVPixelFeatureUsedNameProfile:
    return @"Profile";
  default:
    return @"Unknown";
    break;
  }
}

@end

@implementation BVPixelImpressionContentTypeUtil

+ (NSString *)toString:(BVPixelImpressionContentType)contentType {
  switch (contentType) {
  case BVPixelImpressionContentTypeAnswer:
    return @"Answer";
    break;
  case BVPixelImpressionContentTypeQuestion:
    return @"Question";
    break;
  case BVPixelImpressionContentTypeReview:
    return @"Review";
    break;
  case BVPixelImpressionContentTypeComment:
    return @"Comment";
    break;
  case BVPixelImpressionContentCurationsFeedItem:
    return @"SocialPost";
    break;
  case BVPixelImpressionContentProductRecommendation:
    return @"Recommendation";
  default:
    return @"Unknown";
    break;
  }
}

@end

@implementation BVPixelProductTypeUtil

+ (NSString *)toString:(BVPixelProductType)productType {
  switch (productType) {
  case BVPixelProductTypeConversationsReviews:
    return @"RatingsAndReviews";
  case BVPixelProductTypeConversationsQuestionAnswer:
    return @"AskAndAnswer";
  case BVPixelProductTypeConversationsProfile:
    return @"Profiles";
  case BVPixelProductTypeLocation:
    return @"Location";
  case BVPixelProductTypePIN:
    return @"PIN";
  case BVPixelProductTypeProductRecommendations:
    return @"Recommendations";
  case BVPixelProductTypeCurations:
    return @"Curations";
  default:
    return @"UnknownProduct";
  }
}

@end
