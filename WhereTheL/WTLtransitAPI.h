//
//  WTLtransitAPI.h
//  WhereTheL
//
//  Created by Lukas Thoms on 7/10/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyctSubwayProtoTxt.pb.h"

@interface WTLtransitAPI : NSObject

@property (strong, nonatomic) NSArray *vehicleEntities;
@property (strong, nonatomic) NSArray *tripEntities;

+ (id)sharedData;

-(void) refreshMTADataWithCompletion: (void (^) (FeedMessage *message))completion;

-(void) retrieveAPIDataFromParseWithCompletion: (void (^)(FeedMessage *message))completion;

@end