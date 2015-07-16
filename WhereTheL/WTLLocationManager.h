//
//  WTLLocationManager.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/12/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "WTLStationManager.h"

@interface WTLLocationManager : CLLocationManager

@property (strong, nonatomic) WTLStationManager *stationManager;
@property (strong, nonatomic) WTLStation *nearestStation;

-(instancetype) init;

-(WTLStation *) nearestStation;

@end
