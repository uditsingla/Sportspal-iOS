//
//  SportsManager.h
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

//protocol to notify view controller
@protocol ViewSportsDelegate <NSObject>

-(void)newGameCreated:(Game*)game;

@end

@interface SportsManager : NSObject

@property(nonatomic,strong) NSMutableArray *arraySports;
@property(nonatomic,strong) NSMutableArray *arrayGames;
@property(nonatomic,strong) NSMutableArray *arraySearchedGames;

@property(nonatomic,strong) NSMutableArray *arrayGameChallenges;
@property(nonatomic,strong) NSMutableArray *arrayIndividualGameRequests;

@property(weak,nonatomic) id<ViewSportsDelegate> sportsManagerDelegate;


-(void)getSports:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getAvailableGames:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getAvailableGamesWithSearchTerm:(NSString *)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)createNewGame:(Game*)game completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)searchGameWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getAllGameChallenges:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getAllIndividualGameRequests:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)resetModelData;

@end
