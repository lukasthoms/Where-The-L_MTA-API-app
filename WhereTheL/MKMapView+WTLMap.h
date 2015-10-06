//
//  MKMapView+WTLMap.h
//  WhereTheL
//
//  Created by Lukas Thoms on 10/6/15.
//  Copyright © 2015 Lukas Thoms. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (WTLMap)

-(void)setupMapRegionWithCurrentLocation:(CLLocation *)currentLocation storeLocation:(CLLocation *)storeLocation;

@end
