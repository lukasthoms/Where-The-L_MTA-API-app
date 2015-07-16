//
//  WTLTheLStations.m
//  WhereTheL
//
//  Created by Lukas Thoms on 7/11/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "WTLStationManager.h"
#import "WTLtransitAPI.h"

@implementation WTLStationManager

-(instancetype) initWithStations {
    self = [super init];
    WTLStation *eightAve = [[WTLStation alloc] initWithName:@"8th Avenue"
                                                  shortName:@"8th Av"
                                                     stopID:@"L01"
                                                   location:[[CLLocation alloc] initWithLatitude:40.7394387
                                                                                       longitude:-74.0024851]];
    WTLStation *sixthAve = [[WTLStation alloc] initWithName:@"6th Avenue"
                                                  shortName:@"6th Av"
                                                     stopID:@"L02"
                                                   location:[[CLLocation alloc] initWithLatitude:40.7372519
                                                                                       longitude:-73.9988802]];
    WTLStation *unionSquare = [[WTLStation alloc] initWithName:@"Union Square"
                                                     shortName:@"Union Sq"
                                                        stopID:@"L03"
                                                      location:[[CLLocation alloc] initWithLatitude:40.7351708
                                                                                          longitude:-73.9921747]];
    WTLStation *thirdAve = [[WTLStation alloc] initWithName:@"3rd Avenue"
                                                  shortName:@"3rd Av"
                                                     stopID:@"L04"
                                                   location:[[CLLocation alloc] initWithLatitude:40.7337399
                                                                                       longitude:-73.9892993]];
    WTLStation *firstAve = [[WTLStation alloc] initWithName:@"1st Avenue"
                                                  shortName:@"1st Av"
                                                     stopID:@"L05"
                                                   location:[[CLLocation alloc] initWithLatitude:40.7317318
                                                                                       longitude:-73.9846859]];
    WTLStation *bedfordAve = [[WTLStation alloc] initWithName:@"Bedford Avenue"
                                                    shortName:@"Bedford Av"
                                                       stopID:@"L06"
                                                     location:[[CLLocation alloc] initWithLatitude:40.717758
                                                                                         longitude:-73.9573439]];
    WTLStation *lorimerSt = [[WTLStation alloc] initWithName:@"Lorimer Street"
                                                   shortName:@"Lorimer St"
                                                      stopID:@"L07"
                                                    location:[[CLLocation alloc] initWithLatitude:40.7138709
                                                                                        longitude:-73.953106]];
    WTLStation *grahamAve = [[WTLStation alloc] initWithName:@"Graham Avenue"
                                                   shortName:@"Graham Av"
                                                      stopID:@"L08" location:[[CLLocation alloc] initWithLatitude:40.7136757
                                                                                                        longitude:-73.9446517]];
    WTLStation *grandSt = [[WTLStation alloc] initWithName:@"Grand Street"
                                                 shortName:@"Grand St"
                                                    stopID:@"L09"
                                                  location:[[CLLocation alloc] initWithLatitude:40.7136757
                                                                                      longitude:-73.9446517]];
    WTLStation *montroseAve = [[WTLStation alloc] initWithName:@"Montrose Avenue"
                                                     shortName:@"Montrose Av"
                                                        stopID:@"L10"
                                                      location:[[CLLocation alloc] initWithLatitude:40.7087903
                                                                                          longitude:-73.9407231]];
    WTLStation *morganAve = [[WTLStation alloc] initWithName:@"Morgan Avenue"
                                                   shortName:@"Morgan Av"
                                                      stopID:@"L11"
                                                    location:[[CLLocation alloc] initWithLatitude:40.7062691
                                                                                        longitude:-73.9349403]];
    WTLStation *jeffersonSt = [[WTLStation alloc] initWithName:@"Jefferson Street"
                                                      shortName:@"Jefferson St"
                                                        stopID:@"L12"
                                                      location:[[CLLocation alloc] initWithLatitude:40.7060169
                                                                                          longitude:-73.926089]];
    WTLStation *dekalbAv = [[WTLStation alloc] initWithName:@"DeKalb Avenue"
                                                  shortName:@"DeKalb Av"
                                                     stopID:@"L13"
                                                   location:[[CLLocation alloc] initWithLatitude:40.7038128
                                                                                       longitude:-73.9202418]];
    WTLStation *myrtleAve = [[WTLStation alloc] initWithName:@"Myrtle-Wyckoff Avenues"
                                                   shortName:@"Myrtle/Wyckoff"
                                                      stopID:@"L14"
                                                    location:[[CLLocation alloc] initWithLatitude:40.7004699
                                                                                        longitude:-73.9131929]];
    WTLStation *halseySt = [[WTLStation alloc] initWithName:@"Halsey Street" shortName:@"Halsey St"
                                                     stopID:@"L15"
                                                   location:[[CLLocation alloc] initWithLatitude:40.6959237
                                                                                       longitude:-73.9058351]];
    
    WTLStation *wilsonAve = [[WTLStation alloc] initWithName:@"Wilson Avenue"
                                                   shortName:@"Wilson Av"
                                                      stopID:@"L16" location:[[CLLocation alloc] initWithLatitude:40.6895877
                                                                                                        longitude:-73.9068713]];
    WTLStation *bushwickAve = [[WTLStation alloc] initWithName:@"Bushwick Av - Aberdeen St"
                                                     shortName:@"Bushwick/Aberdeen"
                                                        stopID:@"L17"
                                                      location:[[CLLocation alloc] initWithLatitude:40.6851781
                                                                                          longitude:-73.9074847]];
    WTLStation *broadwayJct = [[WTLStation alloc] initWithName:@"Broadway Junction"
                                                     shortName:@"Broadway Jct"
                                                        stopID:@"L18"
                                                      location:[[CLLocation alloc] initWithLatitude:40.6773182
                                                                                          longitude:-73.9058233]];
    WTLStation *atlanticAve = [[WTLStation alloc] initWithName:@"Atlantic Avenue"
                                                     shortName:@"Atlantic Av"
                                                        stopID:@"L19"
                                                      location:[[CLLocation alloc] initWithLatitude:40.6749423
                                                                                          longitude:-73.9043212]];
    WTLStation *sutterAve = [[WTLStation alloc] initWithName:@"Sutter Avenue"
                                                   shortName:@"Sutter Av"
                                                      stopID:@"L20"
                                                    location:[[CLLocation alloc] initWithLatitude:40.6692462
                                                                                        longitude:-73.9019609]];
    WTLStation *livoniaAve = [[WTLStation alloc] initWithName:@"Livonia Avenue"
                                                    shortName:@"Livonia Av"
                                                       stopID:@"L21"
                                                     location:[[CLLocation alloc] initWithLatitude:40.6653074
                                                                                         longitude:-73.9014888]];
    WTLStation *newLotsAve = [[WTLStation alloc] initWithName:@"New Lots Avenue"
                                                    shortName:@"New Lots Av"
                                                       stopID:@"L22"
                                                     location:[[CLLocation alloc] initWithLatitude:40.6584736
                                                                                          longitude:-73.9058448]];
    WTLStation *e105thSt = [[WTLStation alloc] initWithName:@"East 105th Street"
                                                  shortName:@"E 105th St"
                                                     stopID:@"L23"
                                                   location:[[CLLocation alloc] initWithLatitude:40.6492041
                                                                                        longitude:-73.9061406]];
    WTLStation *canarsie = [[WTLStation alloc] initWithName:@"Canarsie - Rockaway Parkway"
                                                  shortName:@"Canarsie/Rockaway Pkwy"
                                                     stopID:@"L24"
                                                   location:[[CLLocation alloc] initWithLatitude:40.6492041
                                                                                       longitude:-73.9061406]];
    
    NSArray *stations = @[eightAve, sixthAve, unionSquare, thirdAve, firstAve, bedfordAve, lorimerSt, grahamAve, grandSt, montroseAve, morganAve, jeffersonSt, dekalbAv, myrtleAve, halseySt, wilsonAve, bushwickAve, broadwayJct, atlanticAve, sutterAve, livoniaAve, newLotsAve, e105thSt, canarsie];
    _stations = stations;
    return self;
}




@end
