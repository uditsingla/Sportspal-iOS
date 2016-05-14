//
//  Team.h
//  SportsPal
//
//  Created by Arun Jumwal on 5/1/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, TeamType)
{
    TeamTypePrivate,
    TeamTypeCorporate
};

@interface Team : NSObject

@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *sportID;
@property (nonatomic, strong) NSString *sportName;
@property (nonatomic, assign) int memberLimit;
@property (nonatomic, assign) CLLocationCoordinate2D geoLocation;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) User *creator;
@property (nonatomic, assign) TeamType teamType;

@property (nonatomic, strong) NSMutableArray *arrayMembers;

@end
