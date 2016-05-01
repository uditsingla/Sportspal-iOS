//
//  TaskManager.h
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"


@interface LoginManager : NSObject
{
    
}

//user signup
-(void)userSignUp:(NSDictionary *)dictParam  completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
;

//signin
- (void)userLogin:(NSDictionary *)dictParam completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

//reset password
-(void)resetPassword:(NSString*)email completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

//logout
-(void)logout:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

@end
