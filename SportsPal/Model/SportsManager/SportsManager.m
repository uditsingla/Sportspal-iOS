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

@synthesize arrayGames,arraySports,arraySearchedGames;

- (id)init
{
    self = [super init];
    if (self) {
        arrayGames = [NSMutableArray new];
        arraySports = [NSMutableArray new];
        arraySearchedGames = [NSMutableArray new];
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
                     sport.sportID = [[arrGames objectAtIndex:i] valueForKey:@"id"];
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
                     game.gameID = [[arrGames objectAtIndex:i] valueForKey:@"id"];
                     game.gameName = [[arrGames objectAtIndex:i] valueForKey:@"name"];
                     game.sportID = [[arrGames objectAtIndex:i] valueForKey:@"sport_id"];
                     game.sportName = [[[arrGames objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     game.teamID = [[arrGames objectAtIndex:i] valueForKey:@"team_id"];
                     game.date = [[arrGames objectAtIndex:i] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:i] valueForKey:@"time"];
                     game.distance = [NSString stringWithFormat:@"%.0fkm",[[[arrGames objectAtIndex:i] valueForKey:@"distance"] floatValue]];
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:i] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.creator.userID = [[arrGames objectAtIndex:i] valueForKey:@"user_id"];
                     game.creator.firstName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     game.creator.lastName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     game.creator.email = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     
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
                     game.gameID = [[arrGames objectAtIndex:i] valueForKey:@"id"];
                     game.sportID = [[arrGames objectAtIndex:i] valueForKey:@"sport_id"];
                     game.sportName = [[[arrGames objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     game.teamID = [[arrGames objectAtIndex:i] valueForKey:@"team_id"];
                     game.date = [[arrGames objectAtIndex:i] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:i] valueForKey:@"time"];
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:i] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.creator.userID = [[arrGames objectAtIndex:i] valueForKey:@"user_id"];
                     game.creator.firstName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     game.creator.lastName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     game.creator.email = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     
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
    NSString *gameType;
    if(game.gameType == GameTypeIndividual)
        gameType = @"individual";
    else
        gameType = @"team";
    
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:game.sportID,@"sport_id",game.gameName,@"name",game.creator.userID,@"user_id",gameType,@"game_type",game.teamID,@"team_id",game.date,@"date",game.time,@"time",[NSNumber numberWithDouble: game.geoLocation.latitude],@"latitude",[NSNumber numberWithDouble: game.geoLocation.longitude],@"longitude",game.address,@"address", nil];
    
    [RequestManager asynchronousRequestWithPath:gamesPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 game.gameID = [[json valueForKey:@"data"] valueForKey:@"game_id"];
                 
                 [arrayGames addObject:game];
                 [model_manager.profileManager.owner.arrayGames addObject:game];
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
                     game.gameID = [[arrGames objectAtIndex:i] valueForKey:@"id"];
                     game.sportID = [[arrGames objectAtIndex:i] valueForKey:@"sport_id"];
                     game.sportName = [[[arrGames objectAtIndex:i] valueForKey:@"sport"] valueForKey:@"name"];
                     game.teamID = [[arrGames objectAtIndex:i] valueForKey:@"team_id"];
                     game.date = [[arrGames objectAtIndex:i] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:i] valueForKey:@"time"];
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:i] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:i] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:i] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:i] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.creator.userID = [[arrGames objectAtIndex:i] valueForKey:@"user_id"];
                     game.creator.firstName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     game.creator.lastName = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     game.creator.email = [[[arrGames objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     
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

-(void)resetModelData
{
    [arrayGames removeAllObjects];
}

@end
