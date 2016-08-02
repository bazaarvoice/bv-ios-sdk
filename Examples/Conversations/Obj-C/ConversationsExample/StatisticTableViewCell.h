//
//  StatisticTableViewCell.h
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statValueLabel;

@end
