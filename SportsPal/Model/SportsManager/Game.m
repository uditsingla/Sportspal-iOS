//
//  Game.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Game.h"
#import "Sport.h"

@implementation Game

@synthesize gameID,gameName,sportID,sportName,teamID,teamName,date,time,geoLocation,address,gameType,creator,distance,arrayChallenges,createdTime,gameCategory,membersLimit;

- (id)init
{
    self = [super init];
    if (self) {
        gameID = @"";
        gameName = @"";
        sportID = @"";
        sportName = @"";
        teamID = @"";
        teamName = @"";
        gameCategory = @"";
        membersLimit = @"";
        date = @"";
        time = @"";
        geoLocation = CLLocationCoordinate2DMake(0, 0);
        address = @"";
        distance = @"";
        gameType = GameTypeIndividual;
        createdTime = @"";
        creator = [User new];
        arrayChallenges = [NSMutableArray new];
    }
    return self;
}

-(void)getGameChallenges:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/challenge/%@",self.gameID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
                 NSArray *arrUsers = [json valueForKey:@"message"];
                 [arrayChallenges removeAllObjects];
                 [arrayChallenges addObject:self.creator];
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     if([[[arrUsers objectAtIndex:i] valueForKey:@"team_id"] intValue]==0)
                     {
                         User *user = [User new];
                         user.userID = [NSString stringWithFormat:@"%i", [[[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"id"] intValue]];
                         user.firstName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                         user.lastName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                         user.gender = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"gender"];
                         user.profilePic = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                         user.email = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                         user.dob = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                         
                         user.gameChallengeStatus = [[[arrUsers objectAtIndex:i] valueForKey:@"status"] boolValue];
                         user.gameChallengeID = [NSString stringWithFormat:@"%i",[[[arrUsers objectAtIndex:i] valueForKey:@"id"] intValue]];
                         [arrayChallenges addObject:user];
                     }
                     else
                     {
                         
                         Team *team = [Team new];
                         team.teamID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"id"] intValue]];
                         team.sportID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport_id"] intValue]];
                         if([[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"])
                             team.sportName = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"];
                         team.teamName = [[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"];
                         team.memberLimit = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"members_limit"] intValue];
                         team.geoLocation = CLLocationCoordinate2DMake([[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"latitude"] doubleValue], [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"longitude"] doubleValue]);
                         team.address = [[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"address"];
                         if([[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_type"] isEqualToString:@"private"])
                             team.teamType = TeamTypePrivate;
                         else
                             team.teamType = TeamTypeCorporate;
                         
                         team.creator.userID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"creator_id"] intValue]];
                         team.creator.firstName = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"first_name"];
                         team.creator.lastName = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"last_name"];
                         team.creator.email = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"user"] valueForKey:@"email"];
                         
                         team.creator.gameChallengeStatus = [[[arrUsers objectAtIndex:i] valueForKey:@"status"] boolValue];
                         team.creator.gameChallengeID = [NSString stringWithFormat:@"%i",[[[arrUsers objectAtIndex:i] valueForKey:@"id"] intValue]];
                         
                         
                         [arrayChallenges addObject:team];
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

-(void)challengeGameWithTeamID:(NSString *)team_ID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    if(gameType==GameTypeTeam)
        [dictParam setValue:team_ID forKey:@"team_id"];
    
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/challenge/%@",self.gameID] requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
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


-(void)acceptChallengeWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    [dictParam setValue:challengeID forKey:@"challenge_id"];
    
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/acceptchallenge"] requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
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

-(void)declineChallengeWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    //    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    [dictParam setValue:challengeID forKey:@"challenge_id"];
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/challenge"] requestType:RequestTypeDELETE params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
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


-(void)getGameMembers:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/member/%@",self.gameID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 
                 NSArray *arrUsers = [json valueForKey:@"message"];
                 [arrayChallenges removeAllObjects];
                 
                 [arrayChallenges addObject:self.creator];
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     {
                         User *user = [User new];
                         user.userID = [NSString stringWithFormat:@"%i", [[[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"id"] intValue]];
                         user.firstName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                         user.lastName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                         user.gender = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"gender"];
                         user.profilePic = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                         user.email = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                         user.dob = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                         
                         user.gameChallengeStatus = [[[arrUsers objectAtIndex:i] valueForKey:@"status"] boolValue];
                         user.gameChallengeID = [NSString stringWithFormat:@"%i",[[[arrUsers objectAtIndex:i] valueForKey:@"id"] intValue]];
                         
                         NSArray *arrSports = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"sports_preferences"];
                         if(arrSports.count>0)
                             [user.arrayPreferredSports removeAllObjects];
                         for (int j=0; j < arrSports.count; j++) {
                             
                             Sport *sport = [Sport new];
                             sport.sportID = [NSString stringWithFormat:@"%i",[[[arrSports objectAtIndex:j] valueForKey:@"sport_id"] intValue]];
                             sport.sportName = [[[arrSports objectAtIndex:j] valueForKey:@"sport"] valueForKey:@"name"];
                             
                             [user.arrayPreferredSports addObject:sport];
                         }

                         
                         [arrayChallenges addObject:user];
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

-(void)joinGameWithUserID:(NSString *)user_ID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/member/%@",self.gameID] requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
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

-(void)acceptGameRequestWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:challengeID forKey:@"request_id"];
    
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/memberstatus/%@",self.gameID] requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
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

-(void)declineGameRequestWithChallengeID:(NSString*)challengeID completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
        
    [dictParam setValue:challengeID forKey:@"request_id"];
    
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/memberstatus/%@",self.gameID] requestType:RequestTypeDELETE params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
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
