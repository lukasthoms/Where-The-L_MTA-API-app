//
//  WTLScheduleTableViewCell.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/12/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTime;

@end
