//
//  WTLTheLStations.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/11/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTLStation.h"

@interface WTLStationManager : NSObject

@property (strong, nonatomic) NSArray *stations;

-(instancetype) initWithStations;


@end
