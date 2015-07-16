//
//  WTLStation.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/11/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "WTLStation.h"
#import "WTLtransitAPI.h"
#import <MapKit/MapKit.h>

@implementation WTLStation

-(instancetype) initWithName:(NSString*)name shortName:(NSString*)shortName stopID:(NSString*)stopID location:(CLLocation*)location {
    self = [super init];
    _name = name;
    _shortName = shortName;
    _stopID = stopID;
    _location = location;
    _distanceFromUser = 100000;
    _southBoundSchedule = @[];
    _northBoundSchedule = @[];
    return self;
}

-(void) updateStationScheduleWithCompletion: (void(^)(NSArray *allStopUpdates))completion {
    
    WTLtransitAPI *api = [WTLtransitAPI sharedData];
    NSMutableArray *allStopUpdates =[@[]mutableCopy];
    NSMutableArray *northboundTimeUpdateSchedule = [@[]mutableCopy];
    NSMutableArray *southboundTimeUpdateSchedule = [@[]mutableCopy];
    
    [api retrieveAPIDataFromParseWithCompletion:^(FeedMessage *message) {
        
        for (FeedEntity *entity in api.tripEntities) {
            
            TripUpdate *update = entity.tripUpdate;
            for (TripUpdateStopTimeUpdate *stopUpdate in update.stopTimeUpdate) {
                
                [allStopUpdates addObject:stopUpdate];
                if ([stopUpdate.stopId containsString:self.stopID]) {
                    
                    if ([stopUpdate.stopId containsString:@"N"]) {
                        [northboundTimeUpdateSchedule addObject:stopUpdate];
                    } else if ([stopUpdate.stopId containsString:@"S"]) {
                        [southboundTimeUpdateSchedule addObject:stopUpdate];
                    }
                }
            }
        }
        NSMutableArray *northboundSchedule = [@[]mutableCopy];
        NSMutableArray *southboundSchedule = [@[]mutableCopy];
        
        for (TripUpdateStopTimeUpdate *update in northboundTimeUpdateSchedule) {
            
            if ([update.stopId containsString:@"L24"]) {
                NSTimeInterval seconds = (double)update.departure.time;
                NSDate *departureTime = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
                [northboundSchedule addObject:departureTime];
            } else if ([update.stopId containsString:@"L01"]) {
                //do nothing, 8th Ave has no Manhattan-bound departures
            } else {
                NSTimeInterval seconds = (double)update.arrival.time;
                NSDate *arrivalTime = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
                [northboundSchedule addObject:arrivalTime];
            }
        }
        for (TripUpdateStopTimeUpdate *update in southboundTimeUpdateSchedule) {
            
            if ([update.stopId containsString:@"L01"]) {
                NSTimeInterval seconds = (double)update.departure.time;
                NSDate *departureTime = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
                [southboundSchedule addObject:departureTime];
            } else if ([update.stopId containsString:@"L24"]) {
                //do nothing, Carnarsie stop had no Brooklyn-bound departures
            } else {
                NSTimeInterval seconds = (double)update.arrival.time;
                NSDate *arrivalTime = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
                [southboundSchedule addObject:arrivalTime];
            }
        }
        
        self.southBoundSchedule = southboundSchedule;
        self.northBoundSchedule = northboundSchedule;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataRefresh" object:self];
        completion(allStopUpdates);
        

        
    }];
}

-(void) updateStationSchedule {
    [self updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) {    }];
}

-(void) getWalkingTimeToStationUsingLocation: (CLLocation*)location Completion: (void (^)(double seconds))completionHandler {
    
    MKPlacemark *stationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.location.coordinate addressDictionary:nil];
    MKMapItem *stationMapItem = [[MKMapItem alloc] initWithPlacemark:stationPlacemark];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    MKDirectionsRequest *walkingRouteRequest = [[MKDirectionsRequest alloc] init];
    walkingRouteRequest.transportType = MKDirectionsTransportTypeWalking;
    [walkingRouteRequest setSource:mapItem];
    [walkingRouteRequest setDestination:stationMapItem];
    
    MKDirections *walkingRouteDirections = [[MKDirections alloc] initWithRequest:walkingRouteRequest];
    [walkingRouteDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        double walkingTimeInSeconds = 0;
        if (error) {
            NSLog(@"Walking Route Request Error %@", error.description);
        }
        for (MKRoute *route in response.routes) {
            walkingTimeInSeconds += (double)route.expectedTravelTime;
        }
        completionHandler(walkingTimeInSeconds);
    }];
}

-(void) removePastStopsFromSchedule {
    if (![self.northBoundSchedule isEqualToArray:@[]]) {
        NSDate *dateForView = self.northBoundSchedule[0];
        if ([dateForView timeIntervalSinceNow] < 0) {
            NSMutableArray *newSchedule = [self.northBoundSchedule mutableCopy];
            [newSchedule removeObject:[newSchedule firstObject]];
            self.northBoundSchedule = newSchedule;
        }
    }
    if (![self.southBoundSchedule isEqualToArray:@[]]) {
        NSDate *dateForView = self.southBoundSchedule[0];
        if ([dateForView timeIntervalSinceNow] < 0) {
            NSMutableArray *newSchedule = [self.southBoundSchedule mutableCopy];
            [newSchedule removeObject:[newSchedule firstObject]];
            self.southBoundSchedule = newSchedule;
        }
    }
}

@end
