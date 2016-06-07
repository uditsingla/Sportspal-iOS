//
//  SportsManager.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "SportsManager.h"
#import "Sport.h"

@implementation SportsManager

@synthesize arrayGames,arraySports,arraySearchedGames,arrayGameChallenges,sportsManagerDelegate,arrayIndividualGameRequests;

- (id)init
{
    self = [super init];
    if (self) {
        arrayGames = [NSMutableArray new];
        arraySports = [NSMutableArray new];
        arraySearchedGames = [NSMutableArray new];
        arrayGameChallenges = [NSMutableArray new];
        arrayIndividualGameRequests = [NSMutableArray new];
    }
    return self;
}

-(void)getSports:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:sportsPath requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrGames = [json valueForKey:@"message"];
                 [arraySports removeAllObjects];
                 
                 for (int i=0; i < arrGames.count; i++) {
                     
                     Sport *sport = [Sport new];
                     sport.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"id"] intValue]];
                     sport.sportName = [[arrGames objectAtIndex:i] valueForKey:@"name"];
                     sport.status = [[arrGames objectAtIndex:i] valueForKey:@"status"];
                     [arraySports addObject:sport];
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


-(void)getAvailableGames:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"%@/index/%@",gamesPath,model_manager.profileManager.owner.userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrGames = [json valueForKey:@"message"];
                 [arrayGames removeAllObjects];
                 
                 for (int i=0; i < arrGames.count; i++) {
                     
                     Game *game = [Game new];
                     game.gameID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"id"] intValue]];
                     game.gameName = [[arrGames objectAtIndex:i] valueForKey:@"name"];
                     game.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"sport_id"] intValue]];
                     game.sportName = [[[arrGames objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     game.teamID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"team_id"] intValue]];
                     game.gameCategory = [[arrGames objectAtIndex:i] valueForKey:@"game_status"];
                     game.membersLimit = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"member_limit"] intValue]];

                     if([[[arrGames objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"]!=nil && ![[[[arrGames objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"] isEqual:[NSNull null]])
                         game.teamName = [[[arrGames objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"];
                     game.date = [[arrGames objectAtIndex:i] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:i] valueForKey:@"time"];
                     game.distance = [NSString stringWithFormat:@"%.0fkm",[[[arrGames objectAtIndex:i] valueForKey:@"distance"] floatValue]];
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:i] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.creator.userID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"user_id"] intValue]];
                     game.creator.firstName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     game.creator.lastName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     game.creator.email = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     game.creator.profilePic = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                     game.creator.dob = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                     
                     [arrayGames addObject:game];
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

-(void)getAvailableGamesWithSearchTerm:(NSString *)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"%@/index/%@/%@",gamesPath,model_manager.profileManager.owner.userID,searchTerm] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrGames = [json valueForKey:@"message"];
                 [arraySearchedGames removeAllObjects];
                 
                 for (int i=0; i < arrGames.count; i++) {
                     
                     Game *game = [Game new];
                     game.gameName = [[arrGames objectAtIndex:i] valueForKey:@"name"];
                     game.distance = game.distance = [NSString stringWithFormat:@"%.0fkm",[[[arrGames objectAtIndex:i] valueForKey:@"distance"] floatValue]];
                     game.gameID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"id"] intValue]];
                     game.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"sport_id"] intValue]];
                     game.sportName = [[[arrGames objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     game.teamID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"team_id"] intValue]];
                     game.gameCategory = [[arrGames objectAtIndex:i] valueForKey:@"game_status"];
                     game.membersLimit = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"member_limit"] intValue]];

                     game.date = [[arrGames objectAtIndex:i] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:i] valueForKey:@"time"];
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:i] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.creator.userID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"user_id"] intValue]];
                     game.creator.firstName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     game.creator.lastName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     game.creator.email = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     game.creator.profilePic = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                     game.creator.dob = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                     
                     [arraySearchedGames addObject:game];
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

-(void)createNewGame:(Game*)game completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    
    NSDictionary *dictParam;
    
    NSString *gameType;
    if(game.gameType == GameTypeIndividual)
    {
        gameType = @"individual";
        dictParam = [NSDictionary dictionaryWithObjectsAndKeys:game.sportID,@"sport_id",game.gameName,@"name",game.creator.userID,@"user_id",gameType,@"game_type",game.teamID,@"team_id",game.gameCategory,@"game_status",game.membersLimit,@"member_limit",game.date,@"date",game.time,@"time",[NSNumber numberWithDouble: game.geoLocation.latitude],@"latitude",[NSNumber numberWithDouble: game.geoLocation.longitude],@"longitude",game.address,@"address", nil];
    }
    else
    {
        gameType = @"team";
    
        dictParam = [NSDictionary dictionaryWithObjectsAndKeys:game.sportID,@"sport_id",game.gameName,@"name",game.creator.userID,@"user_id",gameType,@"game_type",game.teamID,@"team_id",game.gameCategory,@"game_status",@"1",@"member_limit",game.date,@"date",game.time,@"time",[NSNumber numberWithDouble: game.geoLocation.latitude],@"latitude",[NSNumber numberWithDouble: game.geoLocation.longitude],@"longitude",game.address,@"address", nil];
    }
    
    [RequestManager asynchronousRequestWithPath:gamesPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 game.gameID = [[json valueForKey:@"data"] valueForKey:@"game_id"];
                 
                 [arrayGames insertObject:game atIndex:0];
                 [model_manager.profileManager.owner.arrayGames insertObject:game atIndex:0];
                 
                 [sportsManagerDelegate newGameCreated:game];
             }
             
             if(completionBlock)
                 completionBlock(json,nil);
         }
         else if(completionBlock)
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];
}

-(void)searchGameWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    [dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"is_preferred"];
    
    [dictParam setValue:[NSNumber numberWithBool:NO] forKey:@"is_nearby"];
    
    if(searchTerm)
    {
        [dictParam setValue:searchTerm forKey:@"keyword"];
        [dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"is_keyword"];
    }
    

    
    [RequestManager asynchronousRequestWithPath:searchGamesPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrGames = [json valueForKey:@"message"];
                 [arraySearchedGames removeAllObjects];
                 
                 for (int i=0; i < arrGames.count; i++) {
                     
                     Game *game = [Game new];
                     game.gameName = [[arrGames objectAtIndex:i] valueForKey:@"name"];
                     game.distance = game.distance = [NSString stringWithFormat:@"%.0fkm",[[[arrGames objectAtIndex:i] valueForKey:@"distance"] floatValue]];
                     game.gameID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"id"] intValue]];
                     game.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"sport_id"] intValue]];
                     game.sportName = [[[arrGames objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     game.teamID = [[arrGames objectAtIndex:i] valueForKey:@"team_id"];
                     game.gameCategory = [[arrGames objectAtIndex:i] valueForKey:@"game_status"];
                     game.membersLimit = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"member_limit"] intValue]];
                     game.date = [[arrGames objectAtIndex:i] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:i] valueForKey:@"time"];
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:i] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.creator.userID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:i] valueForKey:@"user_id"] intValue]];
                     game.creator.firstName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     game.creator.lastName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     game.creator.email = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     game.creator.profilePic = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                     game.creator.dob = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                     
                     [arraySearchedGames addObject:game];
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

//for team games
-(void)getAllGameChallenges:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/users/%@",model_manager.profileManager.owner.userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 [arrayGameChallenges removeAllObjects];
                 
                 NSArray *arrGames = [json valueForKey:@"message"];
                 
                 for (int k=0; k < arrGames.count; k++) {
                     
                     NSArray *arrUsers = [[arrGames objectAtIndex:k] valueForKey:@"game_challenges"];
                     if(arrUsers.count>0)
                     {
                         
                         
                         for (int i=0; i < arrUsers.count; i++) {
                             
                             Game *game = [Game new];
                             
                             game.gameID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"id"] intValue]];
                             game.gameName = [[arrGames objectAtIndex:k] valueForKey:@"name"];
                             game.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"sport_id"] intValue]];
                             game.sportName = [[[arrGames objectAtIndex:k] valueForKey:@"sport"] valueForKey:@"name"];
                             game.teamID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"team_id"] intValue]];
                             if([[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"]!=nil && ![[[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"] isEqual:[NSNull null]])
                                 game.teamName = [[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"];
                             game.date = [[arrGames objectAtIndex:k] valueForKey:@"date"];
                             game.time = [[arrGames objectAtIndex:k] valueForKey:@"time"];
                             game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:k] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:k] valueForKey:@"longitude"] doubleValue]);
                             game.address = [[arrGames objectAtIndex:k] valueForKey:@"address"];
                             if([[[arrGames objectAtIndex:k] valueForKey:@"game_type"] isEqualToString:@"individual"])
                                 game.gameType = GameTypeIndividual;
                             else
                                 game.gameType = GameTypeTeam;
                             
                             game.creator.userID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"user_id"] intValue]];
                             //game.creator.firstName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"first_name"];
                             //game.creator.lastName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"last_name"];
                             //game.creator.email = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"email"];
                             
                             
                             game.createdTime = [[arrUsers objectAtIndex:i] valueForKey:@"created"];
                             
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
                                 [game.arrayChallenges addObject:user];
                             }
                             else
                             {
                                 
                                 Team *team = [Team new];
                                 team.teamID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"id"] intValue]];
                                 team.sportID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport_id"] intValue]];
                                 if([[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"])
                                     team.sportName = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"];
                                 if([[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"])
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
                                 
                                 
                                 [game.arrayChallenges addObject:team];
                             }
                             
                             [arrayGameChallenges addObject:game];
                         }

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

-(void)getAllIndividualGameRequests:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"games/memberrequests/%@",model_manager.profileManager.owner.userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 [arrayIndividualGameRequests removeAllObjects];
                 
                 NSArray *arrGames = [json valueForKey:@"message"];
                 
                 for (int k=0; k < arrGames.count; k++) {
                     
                     NSArray *arrUsers = [[arrGames objectAtIndex:k] valueForKey:@"game_members"];
                     if(arrUsers.count>0)
                     {
                         
                         
                         for (int i=0; i < arrUsers.count; i++) {
                             
                             if([[[arrUsers objectAtIndex:i] valueForKey:@"status"] boolValue])
                             {
                                 
                             }
                             else
                             {
                                 Game *game = [Game new];
                                 
                                 game.gameID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"id"] intValue]];
                                 game.gameName = [[arrGames objectAtIndex:k] valueForKey:@"name"];
                                 game.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"sport_id"] intValue]];
                                 game.sportName = [[[arrGames objectAtIndex:k] valueForKey:@"sport"] valueForKey:@"name"];
                                 game.teamID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"team_id"] intValue]];
                                 if([[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"]!=nil && ![[[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"] isEqual:[NSNull null]])
                                     game.teamName = [[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"];
                                 game.date = [[arrGames objectAtIndex:k] valueForKey:@"date"];
                                 game.time = [[arrGames objectAtIndex:k] valueForKey:@"time"];
                                 game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:k] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:k] valueForKey:@"longitude"] doubleValue]);
                                 game.address = [[arrGames objectAtIndex:k] valueForKey:@"address"];
                                 if([[[arrGames objectAtIndex:k] valueForKey:@"game_type"] isEqualToString:@"individual"])
                                     game.gameType = GameTypeIndividual;
                                 else
                                     game.gameType = GameTypeTeam;
                                 
                                 game.creator.userID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"user_id"] intValue]];
                                 game.creator.firstName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"first_name"];
                                 game.creator.lastName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"last_name"];
                                 game.creator.email = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"email"];
                                 game.creator.profilePic = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"image"];
                                 game.creator.dob = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"dob"];
                                 
                                 
                                 game.createdTime = [[arrUsers objectAtIndex:i] valueForKey:@"created"];
                                 
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
                                     
                                     NSArray *arrSports = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"sports_preferences"];
                                     if(arrSports.count>0)
                                         [user.arrayPreferredSports removeAllObjects];
                                     for (int j=0; j < arrSports.count; j++) {
                                         
                                         Sport *sport = [Sport new];
                                         sport.sportID = [NSString stringWithFormat:@"%i",[[[arrSports objectAtIndex:j] valueForKey:@"sport_id"] intValue]];
                                         sport.sportName = [[[arrSports objectAtIndex:j] valueForKey:@"sport"] valueForKey:@"name"];
                                         
                                         [user.arrayPreferredSports addObject:sport];
                                     }
                                     
                                     [game.arrayChallenges addObject:user];
                                 }
                                 else
                                 {
                                     
                                     Team *team = [Team new];
                                     team.teamID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"id"] intValue]];
                                     team.sportID = [NSString stringWithFormat:@"%i",[[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport_id"] intValue]];
                                     if([[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"])
                                         team.sportName = [[[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"sport"] valueForKey:@"name"];
                                     if([[[arrUsers objectAtIndex:i] valueForKey:@"team"] valueForKey:@"team_name"])
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
                                     
                                     
                                     [game.arrayChallenges addObject:team];
                                 }
                                 
                                 [arrayIndividualGameRequests addObject:game];
                             }
                         }
                         
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
    [arrayGames removeAllObjects];
}

@end
