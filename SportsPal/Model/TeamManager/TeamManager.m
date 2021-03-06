//
//  TeamManager.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "TeamManager.h"

@implementation TeamManager

@synthesize arrayTeams,arraySearchedTeams,arrayTeamInvites,teamManagerDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        arrayTeams = [NSMutableArray new];
        arraySearchedTeams = [NSMutableArray new];
        arrayTeamInvites = [NSMutableArray new];
    }
    return self;
}

-(void)getAvailableTeams:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:teamsPath requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrTeams = [json valueForKey:@"message"];
                 [arrayTeams removeAllObjects];
                 
                 for (int i=0; i < arrTeams.count; i++) {
                     
                     Team *team = [Team new];
                     team.teamID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:i] valueForKey:@"id"] intValue]];
                     team.sportID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:i] valueForKey:@"sport_id"] intValue]];
                     team.sportName = [[[arrTeams objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     team.teamName = [[arrTeams objectAtIndex:i] valueForKey:@"team_name"];
                     team.memberLimit = [[[arrTeams objectAtIndex:i] valueForKey:@"members_limit"] intValue];
                     team.geoLocation = CLLocationCoordinate2DMake([[[arrTeams objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrTeams objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     team.address = [[arrTeams objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrTeams objectAtIndex:i] valueForKey:@"team_type"] isEqualToString:@"private"])
                         team.teamType = TeamTypePrivate;
                     else
                         team.teamType = TeamTypeCorporate;
                     
                     team.creator.userID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:i] valueForKey:@"creator_id"] intValue]];
                     team.creator.firstName = [[[arrTeams objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     team.creator.lastName = [[[arrTeams objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     team.creator.email = [[[arrTeams objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     
                     [arrayTeams addObject:team];
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

-(void)createNewTeam:(Team*)team completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSString *teamType;
    if(team.teamType == TeamTypePrivate)
        teamType = @"private";
    else
        teamType = @"corporate";
    
    NSMutableArray *playerIDs = [NSMutableArray new];
    for (User *user in team.arrayMembers) {
        [playerIDs addObject:user.userID];
    }
    
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:team.sportID,@"sport_id",team.creator.userID,@"creator_id",teamType,@"team_type",team.teamName,@"team_name",[NSNumber numberWithInt:team.memberLimit],@"members_limit",[NSNumber numberWithDouble: team.geoLocation.latitude],@"latitude",[NSNumber numberWithDouble: team.geoLocation.longitude],@"longitude",team.address,@"address",playerIDs,@"team_members", nil];
    
    [RequestManager asynchronousRequestWithPath:teamsPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 team.teamID = [[json valueForKey:@"data"] valueForKey:@"team_id"];
                 
                 [arrayTeams insertObject:team atIndex:0];
                 [model_manager.profileManager.owner.arrayTeams insertObject:team atIndex:0];
                 
                 [teamManagerDelegate newTeamCreated:team];
             }
             
             if(completionBlock)
                 completionBlock(json,nil);
         }
         else if(completionBlock)
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];
}

-(void)searchTeamWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    [dictParam setValue:[NSNumber numberWithBool:NO] forKey:@"is_preferred"];
    
    [dictParam setValue:[NSNumber numberWithBool:NO] forKey:@"is_nearby"];
    
    if(searchTerm)
    {
        [dictParam setValue:searchTerm forKey:@"keyword"];
        [dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"is_keyword"];
    }

    
    [RequestManager asynchronousRequestWithPath:searchTeamsPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrTeams = [json valueForKey:@"message"];
                 [arraySearchedTeams removeAllObjects];
                 
                 for (int i=0; i < arrTeams.count; i++) {
                     
                     Team *team = [Team new];
                     team.teamID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:i] valueForKey:@"id"] intValue]];
                     team.sportID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:i] valueForKey:@"sport_id"] intValue]];
                     team.sportName = [[[arrTeams objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     team.teamName = [[arrTeams objectAtIndex:i] valueForKey:@"team_name"];
                     team.memberLimit = [[[arrTeams objectAtIndex:i] valueForKey:@"members_limit"] intValue];
                     team.geoLocation = CLLocationCoordinate2DMake([[[arrTeams objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrTeams objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     team.address = [[arrTeams objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrTeams objectAtIndex:i] valueForKey:@"team_type"] isEqualToString:@"private"])
                         team.teamType = TeamTypePrivate;
                     else
                         team.teamType = TeamTypeCorporate;
                     
                     team.creator.userID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:i] valueForKey:@"creator_id"] intValue]];
                     team.creator.firstName = [[[arrTeams objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     team.creator.lastName = [[[arrTeams objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     team.creator.email = [[[arrTeams objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     
                     [arraySearchedTeams addObject:team];
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

-(void)getTeamInvitation:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"teams/user_team_request/%@",model_manager.profileManager.owner.userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrTeams = [json valueForKey:@"message"];
                 [arrayTeamInvites removeAllObjects];
                 
                 for (int i=0; i < arrTeams.count; i++) {
                     
                     
                     if ([[arrTeams objectAtIndex:i] valueForKey:@"team"] != [NSNull null])
                     {
                         Team *team = [Team new];
                         
                         team.teamID = [NSString stringWithFormat:@"%i",[[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"id"] intValue]];
                         team.sportID = [NSString stringWithFormat:@"%i",[[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport_id"] intValue]];
                         team.sportName = [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"];
                         team.teamName = [[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"];
                         team.createdTime = [[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"created"];
                         
                         team.memberLimit = [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"members_limit"] intValue];
                         team.geoLocation = CLLocationCoordinate2DMake([[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"latitude"] doubleValue], [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"longitude"] doubleValue]);
                         team.address = [[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"address"];
                         if([[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_type"] isEqualToString:@"private"])
                             team.teamType = TeamTypePrivate;
                         else
                             team.teamType = TeamTypeCorporate;
                         
                         team.creator.userID = [NSString stringWithFormat:@"%i",[[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"creator_id"] intValue]];
                         team.creator.firstName = [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"first_name"];
                         team.creator.lastName = [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"last_name"];
                         team.creator.email = [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"email"];
                         team.creator.profilePic = [[[[arrTeams objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"image"];
                         
                         
                         [arrayTeamInvites addObject:team];
                     }
                     
                     
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

-(void)resetModelData
{
    [arrayTeams removeAllObjects];
}

@end
