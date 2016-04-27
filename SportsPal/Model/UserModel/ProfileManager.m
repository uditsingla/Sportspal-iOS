//
//  ProfileManager.m
//  SportsPal
//
//  Created by Abhishek Singla on 28/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "ProfileManager.h"

@implementation ProfileManager

@synthesize owner;

- (id)init
{
    self = [super init];
    if (self) {
        owner = [User new];
    }
    return self;
}

@end
