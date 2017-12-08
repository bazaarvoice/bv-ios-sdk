//
//  BVQuestionView.h
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestion.h"
#import <UIKit/UIKit.h>

/**
 A sub-classed UIView cell that contains one BVQuestion object for display.
 Clients should provide their one xib for the view.
 */
@interface BVQuestionView : UIView

/// The Conversations Question associated with this view
@property(strong, nonatomic) BVQuestion *question;

@end
