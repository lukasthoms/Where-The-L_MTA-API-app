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
#import <Masonry.h>
#import <SVProgressHUD.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet WTLScheduleTableView *scheduleTableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingDistanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) BOOL reloadSuspended;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.stationLabel.font = [UIFont flatFontOfSize:20];
    [self locationSetup];
    [self tableViewSetup];
    [SVProgressHUD show];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"BecameActive"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"dataRefresh"
                                               object:nil];
}

-(void)tableViewSetup {
    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    self.scheduleTableView.separatorColor = [UIColor clearColor];
    self.reloadSuspended = NO;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.scheduleTableView addSubview:refreshControl];
}

-(void)locationSetup {
    self.locationManager = [[WTLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.walkingDistanceLabel.font = [UIFont flatFontOfSize:13];
    self.walkingDistanceLabel.text = @"";
    self.mapView.delegate = self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
    [self.locationManager.nearestStation updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) { }];
    [self updateWalkingDirections];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager nearestStation];
    [self.locationManager.nearestStation removePastStopsFromSchedule];
    if (!self.reloadSuspended) {
        [self.scheduleTableView reloadData];
    }
    
    if (![self.locationManager.nearestStation.name isEqual:self.stationLabel.text]) {
        [SVProgressHUD show];
        self.stationLabel.text = self.locationManager.nearestStation.name;
        [self.locationManager.nearestStation updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) {
            [SVProgressHUD dismiss];
        }];
        [self.mapView setupMapRegionWithCurrentLocation:self.locationManager.location stationLocation:self.locationManager.nearestStation.location];
        [self updateWalkingDirections];
        
    }

    
}

-(void)updateWalkingDirections {
    [self.locationManager.nearestStation getWalkingDirectionsWithTimeToStationUsingLocation:self.locationManager.location Completion:^(double seconds, NSArray *routes) {
        self.walkingDistanceLabel.text = [NSString stringWithFormat: @"You are a %.0f minute walk away", (seconds/60)];
        for (MKRoute *route in routes) {
            [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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
    /* build view */
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    [view setBackgroundColor:[UIColor colorWithRed:186/255.0 green:197/255.0 blue:206/255.0 alpha:1]];
    /* build direction label */
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont flatFontOfSize:17]];
    NSString *string = @"";
    if (section == 0) {
        string = @"Manhattan Bound";
    } else {
        string = @"Brooklyn Bound";
    }
    [label setText:string];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).with.offset(8);
    }];
    /* build interval label */
    UILabel *interval = [[UILabel alloc] init];
    [interval setFont:[UIFont flatFontOfSize:17]];
    NSString *intervalString = @"";
    NSDictionary *intervals;
    if (section == 0) {
        intervals = [self.locationManager.nearestStation northboundArrivalsIntervals];
    } else {
        intervals = [self.locationManager.nearestStation southboundArrivalsIntervals];
    }
    if (intervals[@"averageInterval"]) {
        intervalString = [NSString stringWithFormat:@"every %@ minutes", intervals[@"averageInterval"]];
    } else if (intervals[@"firstInterval"] && intervals[@"secondInterval"]) {
        intervalString = [NSString stringWithFormat:@"every %@ and %@ minutes", intervals[@"firstInterval"], intervals[@"secondInterval"]];
    }
    [interval setText:intervalString];
    [view addSubview:interval];
    [interval mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).with.offset(-8);
    }];

    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTLScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell" forIndexPath:indexPath];
    cell.scheduleLabel.font = [UIFont flatFontOfSize:15];
    cell.arrivalTime.font = [UIFont flatFontOfSize:15];
    
    NSDate *dateForView;
    if (indexPath.section == 0) {
        dateForView = self.locationManager.nearestStation.northBoundSchedule[indexPath.row];

    } else {
        dateForView = self.locationManager.nearestStation.southBoundSchedule[indexPath.row];
    }
    cell.scheduleLabel.text = [NSString stringWithFormat:@"%.0f minutes away", ([dateForView timeIntervalSinceNow]/60)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    cell.arrivalTime.text = [NSString stringWithFormat:@"arriving at %@", [formatter stringFromDate:dateForView]];
    return cell;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BecameActive"]) {
        [self.locationManager startUpdatingLocation];
    }
    if ([[notification name] isEqualToString:@"dataRefresh"] && !self.reloadSuspended) {
        [self.scheduleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.locationManager.nearestStation updateStationScheduleWithCompletion:^(NSArray *allStopUpdates) {
        [self updateWalkingDirections];
        [refreshControl endRefreshing];
    }];
    
    
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
