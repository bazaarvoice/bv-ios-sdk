//
//  BVQuestionsTableView.h
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVQuestionsAndAnswersRequest.h"

/// A sub-classed UITableView for displaying BVQuestionTableViewCells
@interface BVQuestionsTableView : UITableView

/// Helper method to asynchronously load the Questions for given request. This
/// helper also ensures the proper analytic tracking is fired for reporting.
- (void)load:(nonnull BVQuestionsAndAnswersRequest *)request
     success:(nonnull QuestionsAndAnswersSuccessHandler)success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
