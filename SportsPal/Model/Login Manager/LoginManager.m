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
//#import <GooglePlus/GooglePlus.h>


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
            completionBlock(json,nil);
            
            if([[json valueForKey:@"message"] isKindOfClass:[NSDictionary class]])
            {
                model_manager.profileManager.owner.strUserID = [[json valueForKey:@"message"] valueForKey:@"id"];
                model_manager.profileManager.owner.strFirstName = [[json valueForKey:@"message"] valueForKey:@"first_name"];
                model_manager.profileManager.owner.strLastName = [[json valueForKey:@"message"] valueForKey:@"last_name"];
                model_manager.profileManager.owner.strGender = [[json valueForKey:@"message"] valueForKey:@"gender"];
                model_manager.profileManager.owner.strProfilePic = [[json valueForKey:@"message"] valueForKey:@"image"];
                model_manager.profileManager.owner.strEmail = [[json valueForKey:@"message"] valueForKey:@"email"];
            }
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
             completionBlock(json,nil);
         else
             completionBlock(nil,nil);         NSLog(@"Here comes the json %@",json);
     } ];

}

-(void)logout
{
    
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
