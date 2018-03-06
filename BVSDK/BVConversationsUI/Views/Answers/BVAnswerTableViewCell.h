//
//  BVAnswerTableViewCell.h
//  BVConersations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import <UIKit/UIKit.h>

/**
A sub-classed UITableViewCell cell that contains one BVAnswer object for
display. Clients should provide their one xib for the view.
 */
@interface BVAnswerTableViewCell : UITableViewCell

/// The Conversations Answer associated with this tableViewCell
@property(strong, nonatomic) BVAnswer *answer;

@end
