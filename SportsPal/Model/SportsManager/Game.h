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
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *sportID;
@property (nonatomic, strong) NSString *sportName;
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *gameCategory;
@property (nonatomic, strong) NSString *membersLimit;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) CLLocationCoordinate2D geoLocation;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *createdTime;


@property (nonatomic, strong) User *creator;
@property (nonatomic, assign) GameType gameType;

@property (nonatomic, strong) NSMutableArray *arrayChallenges;

//for team
-(void)getGameChallenges:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)challengeGameWithTeamID:(NSString *)team_ID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)acceptChallengeWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)declineChallengeWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

//for individual
-(void)getGameMembers:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)joinGameWithUserID:(NSString *)user_ID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)acceptGameRequestWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)declineGameRequestWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

@end
