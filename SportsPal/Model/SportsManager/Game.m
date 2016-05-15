//
//  Game.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize gameID,gameName,sportID,sportName,teamID,date,time,geoLocation,address,gameType,creator,distance;

- (id)init
{
    self = [super init];
    if (self) {
        gameID = @"";
        gameName = @"";
        sportID = @"";
        sportName = @"";
        teamID = @"";
        date = @"";
        time = @"";
        geoLocation = CLLocationCoordinate2DMake(0, 0);
        address = @"";
        distance = @"";
        gameType = GameTypeIndividual;
        creator = [User new];
    }
    return self;
}

@end
