//
//  WTLCollectionReusableView.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/17/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingDistanceLabel;

@end
