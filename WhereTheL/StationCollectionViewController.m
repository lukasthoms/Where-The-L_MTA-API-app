//
//  StationCollectionViewController.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/17/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "StationCollectionViewController.h"
#import "StationCollectionViewCell.h"
#import "UIFont+FlatUI.h"
#import <MapKit/MapKit.h>
#import "WTLtransitAPI.h"
#import "WTLCollectionReusableView.h"

@interface StationCollectionViewController ()

@end

@implementation StationCollectionViewController

static NSString * const reuseIdentifier = @"stationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[WTLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionViewLayout.dew]
    [self.collectionView registerClass:[StationCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[WTLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"stationHeader"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"BecameActive"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"dataRefresh"
                                               object:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WTLCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"stationHeader" forIndexPath:indexPath];
    header.stationLabel.text = self.locationManager.nearestStation.name;
    [self.locationManager.nearestStation getWalkingTimeToStationUsingLocation:self.locationManager.location Completion:^(double seconds) {
        header.walkingDistanceLabel.text = [NSString stringWithFormat: @"You are a %.0f minute walk away", (seconds/60)];
    }];
    return header;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    [self.locationManager nearestStation];
    [self.collectionView reloadData];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self.locationManager.nearestStation removePastStopsFromSchedule];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.scheduleTimeLabel.font = [UIFont flatFontOfSize:15];
    cell.arrivalTimeLabel.font = [UIFont flatFontOfSize:15];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    if (indexPath.section == 0) {
        NSDate *dateForView = self.locationManager.nearestStation.northBoundSchedule[indexPath.row];
        cell.scheduleTimeLabel.text = [NSString stringWithFormat:@"%.0f minutes away", ([dateForView timeIntervalSinceNow]/60)];
        cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"arriving at %@", [formatter stringFromDate:dateForView]];
        
    } else {
        NSDate *dateForView = self.locationManager.nearestStation.southBoundSchedule[indexPath.row];
        cell.scheduleTimeLabel.text = [NSString stringWithFormat:@"%.0f minutes away", ([dateForView timeIntervalSinceNow]/60)];
        cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"arriving at %@", [formatter stringFromDate:dateForView]];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BecameActive"]) {
        [self.locationManager startUpdatingLocation];
    }
    if ([[notification name] isEqualToString:@"dataRefresh"]) {
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
}

@end
