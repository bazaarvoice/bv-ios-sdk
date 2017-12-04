//
//  BVAnswerView.h
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import <UIKit/UIKit.h>

/**
A sub-classed UIView cell that contains one BVAnswer object for display.
Clients should provide their one xib for the view.
*/
@interface BVAnswerView : UIView

/// The Conversations Answer associated with this view
@property(strong, nonatomic) BVAnswer *answer;

@end
