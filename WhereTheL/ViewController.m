//
//  ViewController.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/10/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "ViewController.h"
#import "NyctSubwayProtoTxt.pb.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSession *sesh = [NSURLSession sharedSession];
    NSURL *mtaCall = [NSURL URLWithString:@"http://datamine.mta.info/mta_esi.php?key=8365fd8b2dddf1d6145d3b9f9cbd0fdb&feed_id=2"];
    NSURLSessionDataTask *task = [sesh dataTaskWithURL:mtaCall completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        }
        FeedMessage *feed = [FeedMessage parseFromData:data];
        NSLog(@"Feed! %@",feed);
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
