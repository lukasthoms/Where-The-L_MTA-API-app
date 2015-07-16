//
//  WTLLocationManager.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/12/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "WTLLocationManager.h"

@implementation WTLLocationManager

-(instancetype) init {
    self = [super init];
    _stationManager = [[WTLStationManager alloc] initWithStations];
    return self;
}

-(WTLStation *) nearestStation {
    for (WTLStation *station in self.stationManager.stations) {
        station.distanceFromUser = [self.location distanceFromLocation:station.location];
    }
    NSSortDescriptor *nearestStation = [[NSSortDescriptor alloc] initWithKey:@"distanceFromUser" ascending:YES];
    NSArray *descriptors = @[nearestStation];
    NSArray *sortedStations = [self.stationManager.stations sortedArrayUsingDescriptors:descriptors];

    self.nearestStation = [sortedStations firstObject];
    
    return [sortedStations firstObject];
}

@end
