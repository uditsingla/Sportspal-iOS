//
//  Sport.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Sport.h"

@implementation Sport

@synthesize sportID,sportName,status;

- (id)init
{
    self = [super init];
    if (self) {
        sportID = @"";
        sportName = @"";
        status = @"";
    }
    return self;
}

@end
