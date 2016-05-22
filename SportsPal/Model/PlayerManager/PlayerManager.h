//
//  PlayerManager.h
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerManager : NSObject

@property(nonatomic,strong) NSMutableArray *arrayPlayers;

@property(nonatomic,strong) NSMutableArray *arraySearchedPlayers;

-(void)getNearByUsers:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getNearByUsersWithSportID:(NSString *)sportID completion:(void(^)(NSMutableArray *arrayUsers, NSError *error))completionBlock;

-(void)searchPlayerWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)resetModelData;

@end
