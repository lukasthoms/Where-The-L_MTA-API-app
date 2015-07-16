//
//  WTLtransitAPI.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/10/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "WTLtransitAPI.h"
#import "WTLConstants.h"
#import <Parse.h>

@implementation WTLtransitAPI

-(void) refreshMTADataWithCompletion: (void(^)(FeedMessage *message))completion {
    NSURLSession *sesh = [NSURLSession sharedSession];
    NSURL *mtaCall = [NSURL URLWithString:[NSString stringWithFormat:@"http://datamine.mta.info/mta_esi.php?key=%@&feed_id=2", MTA_KEY]];
    NSURLSessionDataTask *task = [sesh dataTaskWithURL:mtaCall completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        }
        FeedMessage *feed = [FeedMessage parseFromData:data extensionRegistry:[NyctSubwayProtoTxtRoot extensionRegistry]];
        
        NSMutableArray *vehicles = [@[]mutableCopy];
        NSMutableArray *trips = [@[]mutableCopy];
        for (FeedEntity *entity in feed.entity) {

            
            if ([entity.id integerValue] % 2 == 1) {
                [trips addObject:entity];
            } else if ([entity.id integerValue] % 2 == 0) {
                [vehicles addObject:entity];
            }
        }
        self.vehicleEntities = vehicles;
        self.tripEntities = trips;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataRefresh" object:self];

        completion(feed);
    }];
    [task resume];
}

+ (id)sharedData {
    static WTLtransitAPI *sharedWTLtransitData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWTLtransitData = [[self alloc] init];
    });
    return sharedWTLtransitData;
}

-(void) retrieveAPIDataFromParseWithCompletion: (void (^)(FeedMessage *message))completion {

    PFQuery *dataQuery = [PFQuery queryWithClassName:@"TrainData"];
    [dataQuery orderByDescending:@"createdAt"];
    [dataQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *returnedFile = object[@"LData"];
        [returnedFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            FeedMessage *feed = [FeedMessage parseFromData:data extensionRegistry:[NyctSubwayProtoTxtRoot extensionRegistry]];
            
            NSMutableArray *vehicles = [@[]mutableCopy];
            NSMutableArray *trips = [@[]mutableCopy];
            for (FeedEntity *entity in feed.entity) {
                
                
                if ([entity.id integerValue] % 2 == 1) {
                    [trips addObject:entity];
                } else if ([entity.id integerValue] % 2 == 0) {
                    [vehicles addObject:entity];
                }
            }
            self.vehicleEntities = vehicles;
            self.tripEntities = trips;

            
            completion(feed);
            if (error) {
                NSLog(@"Error in getData: %@", error.localizedDescription);
            }
        }];
        if (error) {
            NSLog(@"Error in findObjects: %@", error.localizedDescription);
        }
    }];

}

@end
