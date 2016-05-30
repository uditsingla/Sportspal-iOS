//
//  TaskManager.m
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import "LoginManager.h"
//#import "ProfileManager.h"
#import "AppDelegate.h"


@implementation LoginManager


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark Service Calls


- (void)userLogin:(NSDictionary *)dictParam completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:loginPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
    {
        
        if(statusCode==200)
        {
            if([[json valueForKey:@"success"] boolValue])
            {
                model_manager.profileManager.owner.userID = [[json valueForKey:@"message"] valueForKey:@"id"];
                model_manager.profileManager.owner.firstName = [[json valueForKey:@"message"] valueForKey:@"first_name"];
                model_manager.profileManager.owner.lastName = [[json valueForKey:@"message"] valueForKey:@"last_name"];
                model_manager.profileManager.owner.gender = [[json valueForKey:@"message"] valueForKey:@"gender"];
                model_manager.profileManager.owner.profilePic = [[json valueForKey:@"message"] valueForKey:@"image"];
                model_manager.profileManager.owner.email = [[json valueForKey:@"message"] valueForKey:@"email"];
                
                [[NSUserDefaults standardUserDefaults] setValue:model_manager.profileManager.owner.email forKey:@"email"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[[json valueForKey:@"message"] valueForKey:@"usertoken"] forKey:@"DeviceToken"];
                
                if([[[json valueForKey:@"message"] valueForKey:@"latitude"] doubleValue] && [[[json valueForKey:@"message"] valueForKey:@"longitude"] doubleValue])
                {
                    kAppDelegate.myLocation = [[CLLocation alloc] initWithLatitude:[[[json valueForKey:@"message"] valueForKey:@"latitude"] doubleValue] longitude:[[[json valueForKey:@"message"] valueForKey:@"longitude"] doubleValue]];
                    
                    [SVGeocoder reverseGeocode:kAppDelegate.myLocation.coordinate
                                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                                        
                                        if(error)
                                        {
                                            
                                        }
                                        else if([placemarks count]>0)
                                        {
                                            model_manager.profileManager.svp_LocationInfo = [placemarks firstObject];
                                            NSLog(@"Dictonary for google location = %@", [placemarks firstObject]);
                                            
                                        }
                                        
                                    }];
                }
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoLogin"];
                
                [[NSUserDefaults standardUserDefaults] setValue:model_manager.profileManager.owner.userID forKey:@"userID"];
                
                [model_manager.playerManager getNearByUsers:nil];
                [model_manager.sportsManager getAvailableGames:nil];
                [model_manager.teamManager getAvailableTeams:nil];
                [model_manager.profileManager.owner getPreferredSports:nil];
                [model_manager.teamManager getTeamInvitation:nil];
                [model_manager.sportsManager getAllGameChallenges:nil];
            }
            
            completionBlock(json,nil);
        }
        else
            completionBlock(nil,nil);
        
        NSLog(@"Here comes the json %@",json);
    } ];
}

-(void)resetPassword:(NSString*)email completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    [RequestManager asynchronousRequestWithPath:resetPasswordPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
             }
             
             completionBlock(json,nil);
         }
         else
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];

}

-(void)userSignUp:(NSDictionary *)dictParam  completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock

{
    [RequestManager asynchronousRequestWithPath:registerPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
     {
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
             }
             completionBlock(json,nil);
         }
         else
             completionBlock(nil,nil);         NSLog(@"Here comes the json %@",json);
     } ];

}

-(void)logout:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSString *deviceToken=@"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceToken"])
    {
        deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceToken"];
    }

    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"device_type", deviceToken,@"device_token", nil];
    
    [RequestManager asynchronousRequestWithPath:logoutPath requestType:RequestTypeDELETE params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoLogin"];
                 [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userID"];
                 //clear model data
                 [model_manager.profileManager resetModelData];
                 [model_manager.sportsManager resetModelData];
                 [model_manager.playerManager resetModelData];
                 [model_manager.teamManager resetModelData];
                 
                 
                 for (NSHTTPCookie *value in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
                     [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:value];
                 }
             }
             completionBlock(json,nil);
         }
         else
             completionBlock(nil,nil);         NSLog(@"Here comes the json %@",json);
     } ];

}

/*
-(void)userSignUp:(NSDictionary *)dictParam
{
    [model_manager.requestManager asynchronousRequestWithPath:@"user/register" requestType:RequestTypePost params:dictParam timeOut:kTimeout includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     
     {
         
         if(statusCode == 200)
             
         {
             
             int status =[[json valueForKey:@"ErrorCode"] intValue];
             
             if(status==0)
        
             {
                 [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"UserID"] forKey:@"UserID"];
                 //----Set Profile Manager----
                 
                 model_manager.profilemanager.full_name = [[json valueForKey:@"UserData"]valueForKey:@"DisplayName"];
                 model_manager.profilemanager.email = [[json valueForKey:@"UserData"]valueForKey:@"Email"];
                 model_manager.profilemanager.mobile_no = [[json valueForKey:@"UserData"]valueForKey:@"MobileNo"];
                 model_manager.profilemanager.profile_pic = [[json valueForKey:@"UserData"]valueForKey:@"UserImg"];
                 
                 //---------------------------
                 
                 // fire the notification
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserRegistered object:@"success"];
                 
             }
             
             else
                 
             {
                 NSString *message = [json objectForKey:@"ErrorMessage"];
                 [appdelegate showAlert:message];
                 
                 //fire the notification
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserRegistered object:@"failure"];
                 
             }
             
         }
         
         else if(statusCode==400)
             
         {
             NSString *message = [json objectForKey:@"ErrorMessage"];
             [appdelegate showAlert:message];
             
             //fire the notification
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserRegistered object:@"failure"];;
             
         }
         
         else if(statusCode==401)
             
         {
             NSString *message = [json objectForKey:@"ErrorMessage"];
             [appdelegate showAlert:message];
             
             //fire the notification
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserRegistered object:@"failure"];;
             
         }
         
         else if(statusCode==500)
             
         {
             NSString *message = [json objectForKey:@"ErrorMessage"];
             [appdelegate showAlert:message];
             
             //fire the notification
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserRegistered object:@"failure"];;
             
         }
         
         else
             
         {
             NSString *message = [json objectForKey:@"ErrorMessage"];
             [appdelegate showAlert:message];
             
             //fire the notification
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserRegistered object:@"failure"];;
             
         }
         
         
         
     }];
    

}

 */

@end
