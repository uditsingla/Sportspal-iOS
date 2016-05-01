//
//  ModelManager.h
//  ApiTap
//
//  Created by Abhishek Singla on 13/03/16.
//  Copyright © 2016 ApiTap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginManager.h"
#import "ProfileManager.h"
#import "SportsManager.h"
#import "TeamManager.h"
#import "PlayerManager.h"

@interface ModelManager : NSObject

+(ModelManager *)modelManager;

@property(strong,nonatomic) LoginManager *loginManager;
@property(strong,nonatomic) RequestManager *requestManager;
@property(strong,nonatomic) ProfileManager *profileManager;
@property(strong,nonatomic) SportsManager *sportsManager;
@property(strong,nonatomic) TeamManager *teamManager;
@property(strong,nonatomic) PlayerManager *playerManager;
@end
