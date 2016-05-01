//
//  SportsManager.h
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface SportsManager : NSObject

@property(nonatomic,strong) NSMutableArray *arraySports;
@property(nonatomic,strong) NSMutableArray *arrayGames;

-(void)getSports:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getAvailableGames:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)createNewGame:(Game*)game completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)resetModelData;

@end
