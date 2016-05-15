//
//  ProfileManager.h
//  SportsPal
//
//  Created by Abhishek Singla on 28/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "SVGeocoder.h"

@interface ProfileManager : NSObject

@property (nonatomic, strong) User *owner;
@property(strong,nonatomic) SVPlacemark *svp_LocationInfo;

-(void)searchUsersWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSMutableArray *users, NSError *error))completionBlock;

-(void)resetModelData;
@end
