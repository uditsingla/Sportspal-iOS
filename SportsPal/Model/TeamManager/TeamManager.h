//
//  TeamManager.h
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface TeamManager : NSObject

@property(nonatomic,strong) NSMutableArray *arrayTeams;

@property(nonatomic,strong) NSMutableArray *arraySearchedTeams;

@property(nonatomic,strong) NSMutableArray *arrayTeamInvites;


-(void)getAvailableTeams:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)createNewTeam:(Team*)team completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)searchTeamWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getTeamInvitation:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)resetModelData;

@end
