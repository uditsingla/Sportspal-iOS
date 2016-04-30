//
//  Game.h
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, GameType)
{
    GameTypeIndividual,
    GameTypeTeam
};

@interface Game : NSObject

@property (nonatomic, strong) NSString *gameID;
@property (nonatomic, strong) NSString *sportID;
@property (nonatomic, strong) NSString *sportName;
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) CLLocationCoordinate2D geoLocation;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) User *creator;
@property (nonatomic, assign) GameType gameType;

@end
