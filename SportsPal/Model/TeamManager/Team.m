//
//  Team.m
//  SportsPal
//
//  Created by Arun Jumwal on 5/1/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize teamID,sportID,sportName,teamName,memberLimit,geoLocation,address,teamType,creator,arrayMembers,createdTime;

- (id)init
{
    self = [super init];
    if (self) {
        teamID = @"";
        sportID = @"";
        sportName = @"";
        teamName = @"";
        memberLimit = 0;
        geoLocation = CLLocationCoordinate2DMake(0, 0);
        address = @"";
        teamType = TeamTypePrivate;
        createdTime = @"";
        creator = [User new];
        
        arrayMembers = [NSMutableArray new];
    }
    return self;
}

-(void)getTeamDetails:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"teams/singleteam/%@",self.teamID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
                 self.teamID = [[json valueForKey:@"message"] valueForKey:@"id"];
                 self.sportID = [[json valueForKey:@"message"] valueForKey:@"sport_id"];
                 self.sportName = [[[json valueForKey:@"message"] valueForKey:@"sport"] valueForKey:@"name"];
                 self.teamName = [[json valueForKey:@"message"] valueForKey:@"team_name"];
                 self.memberLimit = [[[json valueForKey:@"message"] valueForKey:@"members_limit"] intValue];
                 self.geoLocation = CLLocationCoordinate2DMake([[[json valueForKey:@"message"] valueForKey:@"latitude"] doubleValue], [[[json valueForKey:@"message"] valueForKey:@"longitude"] doubleValue]);
                 self.address = [[json valueForKey:@"message"] valueForKey:@"address"];
                 if([[[json valueForKey:@"message"] valueForKey:@"team_type"] isEqualToString:@"private"])
                     self.teamType = TeamTypePrivate;
                 else
                     self.teamType = TeamTypeCorporate;
                 
                 self.creator.userID = [NSString stringWithFormat:@"%i",[[[json valueForKey:@"message"] valueForKey:@"creator_id"] intValue]];
                 self.creator.firstName = [[[json valueForKey:@"message"] valueForKey:@"user"] valueForKey:@"first_name"];
                 self.creator.lastName = [[[json valueForKey:@"message"] valueForKey:@"user"] valueForKey:@"last_name"];
                 self.creator.email = [[[json valueForKey:@"message"] valueForKey:@"user"] valueForKey:@"email"];
                 
                 NSArray *arrUsers = [[json valueForKey:@"message"] valueForKey:@"team_members"];
                 [arrayMembers removeAllObjects];
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     User *user = [User new];
                     user.userID = [NSString stringWithFormat:@"%i", [[[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"id"] intValue]];
                     user.firstName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     user.lastName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     user.gender = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"gender"];
                     user.profilePic = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                     user.email = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     user.dob = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                     
                     user.teamStatus = [[[arrUsers objectAtIndex:i] valueForKey:@"status"] boolValue];
                     user.teamRequestID = [[arrUsers objectAtIndex:i] valueForKey:@"id"];
                     [arrayMembers addObject:user];
                 }
                 
                 
                 
             }
             
             if(completionBlock)
                 completionBlock(json,nil);
         }
         else if(completionBlock)
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];
}

-(void)acceptTeamRequestWithRequestID:(NSString*)requestID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    [dictParam setValue:requestID forKey:@"request_id"];
    
    [dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"teams/request/%@",self.teamID] requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
             }
             
             if(completionBlock)
                 completionBlock(json,nil);
         }
         else if(completionBlock)
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];
}

-(void)declineTeamRequestWithRequestID:(NSString*)requestID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
//    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    [dictParam setValue:requestID forKey:@"request_id"];
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"teams/request/%@",self.teamID] requestType:RequestTypeDELETE params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
             }
             
             if(completionBlock)
                 completionBlock(json,nil);
         }
         else if(completionBlock)
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];
}

@end
