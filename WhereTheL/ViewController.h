//
//  ViewController.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/10/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import "WTLLocationManager.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) WTLLocationManager *locationManager;

@end

