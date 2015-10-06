//
//  StationCollectionViewCell.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/17/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;

@end
