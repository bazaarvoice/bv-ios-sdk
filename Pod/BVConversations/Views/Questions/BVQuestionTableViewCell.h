//
//  BVQuestionTableViewCell.h
//  BVConersations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestion.h"
#import <UIKit/UIKit.h>

/**
 A sub-classed UITableViewCell cell that contains one BVQuestion object for
 display. Clients should provide their one xib for the view.
 */
@interface BVQuestionTableViewCell : UITableViewCell

/// The Conversations Question associated with this tableViewCell
@property(strong, nonatomic) BVQuestion *question;

@end
