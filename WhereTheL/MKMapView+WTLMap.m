//
//  MKMapView+WTLMap.m
//  WhereTheL
//
//  Created by Lukas Thoms on 10/6/15.
//  Copyright © 2015 Lukas Thoms. All rights reserved.
//

#import "MKMapView+WTLMap.h"

@implementation MKMapView (WTLMap)

-(void)setupMapRegionWithCurrentLocation:(CLLocation *)currentLocation stationLocation:(CLLocation *)storeLocation {
    double latDiff = currentLocation.coordinate.latitude - storeLocation.coordinate.latitude;
    double longDiff = currentLocation.coordinate.longitude - storeLocation.coordinate.longitude;
    
    CLLocationCoordinate2D middlePoint;
    middlePoint.latitude = currentLocation.coordinate.latitude - (latDiff*0.5);
    middlePoint.longitude = currentLocation.coordinate.longitude - (longDiff*0.5);
    
    [self setRegion:MKCoordinateRegionMake(middlePoint, MKCoordinateSpanMake(fabs(latDiff*2),fabs(longDiff*2))) animated:NO];
}

@end
