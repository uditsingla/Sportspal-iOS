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

@interface ModelManager : NSObject

+(ModelManager *)modelManager;

@property(strong,nonatomic) LoginManager *loginManager;
@property(strong,nonatomic) RequestManager *requestManager;
@property(strong,nonatomic) ProfileManager *profileManager;
@end
