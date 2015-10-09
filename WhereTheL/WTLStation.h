//
//  WTLStation.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/11/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WTLStation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSString *stopID;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) CLLocationDistance distanceFromUser;
@property (strong, nonatomic) NSArray *southBoundSchedule;
@property (strong, nonatomic) NSArray *northBoundSchedule;

-(instancetype) initWithName:(NSString*)name shortName:(NSString*)shortName stopID:(NSString*)stopID location:(CLLocation*)location;

-(void) updateStationScheduleWithCompletion: (void(^)(NSArray *allStopUpdates))completion;

-(void) updateStationSchedule;

-(void) getWalkingDirectionsWithTimeToStationUsingLocation: (CLLocation*)location Completion: (void (^)(double seconds, NSArray *routes))completionHandler;

-(NSDictionary *)southboundArrivalsIntervals;
-(NSDictionary *)northboundArrivalsIntervals;

@end
