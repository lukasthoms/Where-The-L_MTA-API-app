//
//  ViewController.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/10/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "ViewController.h"
#import "UIFont+FlatUI.h"
#import "WTLScheduleTableViewCell.h"
#import <MapKit/MapKit.h>
#import "WTLScheduleTableView.h"
#import "WTLtransitAPI.h"
#import "MKMapView+WTLMap.h"

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet WTLScheduleTableView *scheduleTableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingDistanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[WTLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.stationLabel.font = [UIFont flatFontOfSize:20];
    self.walkingDistanceLabel.font = [UIFont flatFontOfSize:13];
    self.walkingDistanceLabel.text = @"";
    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    self.scheduleTableView.separatorColor = [UIColor clearColor];
    self.mapView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"BecameActive"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"dataRefresh"
                                               object:nil];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.scheduleTableView addSubview:refreshControl];
    

}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
    [self.locationManager.nearestStation updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) { }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager nearestStation];
    if (![self.locationManager.nearestStation.name isEqual:self.stationLabel.text]) {
        self.stationLabel.text = self.locationManager.nearestStation.name;
        [self.locationManager.nearestStation updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) { }];
        [self.mapView setupMapRegionWithCurrentLocation:self.locationManager.location storeLocation:self.locationManager.nearestStation.location];
        [self.locationManager.nearestStation getWalkingDirectionsWithTimeToStationUsingLocation:self.locationManager.location Completion:^(double seconds, NSArray *routes) {
            self.walkingDistanceLabel.text = [NSString stringWithFormat: @"You are a %.0f minute walk away", (seconds/60)];
            for (MKRoute *route in routes) {
                [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            }
        }];
    }
    [self.scheduleTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger numberOfSections = 0;
//    if (![self.locationManager.nearestStation.southBoundSchedule isEqual:@[]]) {
//        numberOfSections += 1;
//    }
//    if (![self.locationManager.nearestStation.northBoundSchedule isEqual:@[]]) {
//        numberOfSections += 1;
//    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self removePastStopsFromSchedule];
    if (section == 0) {
        if (self.locationManager.nearestStation.northBoundSchedule.count > 5) {
            return 5;
        } else {
            return self.locationManager.nearestStation.northBoundSchedule.count;
        }
    } else {
        if (self.locationManager.nearestStation.southBoundSchedule.count > 5) {
            return 5;
        } else {
            return self.locationManager.nearestStation.southBoundSchedule.count;
        }
    }
}


- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont flatFontOfSize:17]];
    NSString *string = @"";
    if (section == 0) {
        string = @"Manhattan Bound";
    } else {
        string = @"Brooklyn Bound";
    }
    /* Section header is in 0th index... */
//    label.textAlignment = NSTextAlignmentCenter;
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTLScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell" forIndexPath:indexPath];
    cell.scheduleLabel.font = [UIFont flatFontOfSize:15];
    cell.arrivalTime.font = [UIFont flatFontOfSize:15];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    if (indexPath.section == 0) {
        NSDate *dateForView = self.locationManager.nearestStation.northBoundSchedule[indexPath.row];
        cell.scheduleLabel.text = [NSString stringWithFormat:@"%.0f minutes away", ([dateForView timeIntervalSinceNow]/60)];
        cell.arrivalTime.text = [NSString stringWithFormat:@"arriving at %@", [formatter stringFromDate:dateForView]];

    } else {
        NSDate *dateForView = self.locationManager.nearestStation.southBoundSchedule[indexPath.row];
        cell.scheduleLabel.text = [NSString stringWithFormat:@"%.0f minutes away", ([dateForView timeIntervalSinceNow]/60)];
        cell.arrivalTime.text = [NSString stringWithFormat:@"arriving at %@", [formatter stringFromDate:dateForView]];
    }
    return cell;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BecameActive"]) {
        [self.locationManager startUpdatingLocation];
    }
    if ([[notification name] isEqualToString:@"dataRefresh"]) {
        [self.scheduleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.locationManager.nearestStation updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) {
        [refreshControl endRefreshing];
    }];
    
}

-(void) removePastStopsFromSchedule {
    if (![self.locationManager.nearestStation.northBoundSchedule isEqualToArray:@[]]) {
        NSDate *dateForView = self.locationManager.nearestStation.northBoundSchedule[0];
        if ([dateForView timeIntervalSinceNow] < 0) {
            NSMutableArray *newSchedule = [self.locationManager.nearestStation.northBoundSchedule mutableCopy];
            [newSchedule removeObject:[newSchedule firstObject]];
            self.locationManager.nearestStation.northBoundSchedule = newSchedule;
        }
    }
    if (![self.locationManager.nearestStation.southBoundSchedule isEqualToArray:@[]]) {
        NSDate *dateForView = self.locationManager.nearestStation.southBoundSchedule[0];
        if ([dateForView timeIntervalSinceNow] < 0) {
            NSMutableArray *newSchedule = [self.locationManager.nearestStation.southBoundSchedule mutableCopy];
            [newSchedule removeObject:[newSchedule firstObject]];
            self.locationManager.nearestStation.southBoundSchedule = newSchedule;
        }
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    return nil;
    
}





@end
