//
//  Team.m
//  SportsPal
//
//  Created by Arun Jumwal on 5/1/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize teamID,sportID,sportName,teamName,memberLimit,geoLocation,address,teamType,creator,arrayMembers;

- (id)init
{
    self = [super init];
    if (self) {
        teamID = @"";
        sportID = @"";
        sportName = @"";
        teamName = @"";
        memberLimit = 0;
        geoLocation = CLLocationCoordinate2DMake(0, 0);
        address = @"";
        teamType = TeamTypePrivate;
        creator = [User new];
        
        arrayMembers = [NSMutableArray new];
    }
    return self;
}

@end
