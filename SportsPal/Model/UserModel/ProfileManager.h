//
//  ProfileManager.h
//  SportsPal
//
//  Created by Abhishek Singla on 28/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ProfileManager : NSObject

@property (nonatomic, strong) User *owner;

-(void)resetModelData;
@end
