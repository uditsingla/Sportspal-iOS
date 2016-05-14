//
//  PlayerManager.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "PlayerManager.h"
#import "Sport.h"
#import "Team.h"
#import "Game.h"

@implementation PlayerManager

@synthesize arrayPlayers,arraySearchedPlayers;

- (id)init
{
    self = [super init];
    if (self) {
        arrayPlayers = [NSMutableArray new];
        arraySearchedPlayers = [NSMutableArray new];
    }
    return self;
}

-(void)getNearByUsers:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"users/getuser/%@",model_manager.profileManager.owner.userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrUsers = [json valueForKey:@"message"];
                 [arrayPlayers removeAllObjects];
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     User *user = [User new];
                     user.userID = [[arrUsers objectAtIndex:i] valueForKey:@"id"];
                     user.firstName = [[arrUsers objectAtIndex:i] valueForKey:@"first_name"];
                     user.lastName = [[arrUsers objectAtIndex:i] valueForKey:@"last_name"];
                     user.gender = [[arrUsers objectAtIndex:i] valueForKey:@"gender"];
                     user.profilePic = [[arrUsers objectAtIndex:i] valueForKey:@"image"];
                     user.email = [[arrUsers objectAtIndex:i] valueForKey:@"email"];
                     user.dob = [[arrUsers objectAtIndex:i] valueForKey:@"dob"];
                     
                     NSArray *arrSports = [[arrUsers objectAtIndex:i] valueForKey:@"sports_preferences"];
                     [user.arrayPreferredSports removeAllObjects];
                     for (int j=0; j < arrSports.count; j++) {
                         
                         Sport *sport = [Sport new];
                         sport.sportID = [[arrSports objectAtIndex:j] valueForKey:@"sport_id"];
                         //sport.sportName = [[[arrSports objectAtIndex:j] valueForKey:@"Sports"] valueForKey:@"name"];
                         
                         [user.arrayPreferredSports addObject:sport];
                     }

                     NSArray *arrGames = [[arrUsers objectAtIndex:i] valueForKey:@"games"];
                     [user.arrayGames removeAllObjects];
                     
                     for (int k=0; k < arrGames.count; k++) {
                         
                         Game *game = [Game new];
                         game.gameID = [[arrGames objectAtIndex:k] valueForKey:@"id"];
                         game.sportID = [[arrGames objectAtIndex:k] valueForKey:@"sport_id"];
                         //game.sportName = [[[arrGames objectAtIndex:k] valueForKey:@"sport"] valueForKey:@"name"];
                         game.teamID = [[arrGames objectAtIndex:k] valueForKey:@"team_id"];
                         game.date = [[arrGames objectAtIndex:k] valueForKey:@"date"];
                         game.time = [[arrGames objectAtIndex:k] valueForKey:@"time"];
                         game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:k] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:k] valueForKey:@"longitude"] doubleValue]);
                         game.address = [[arrGames objectAtIndex:k] valueForKey:@"address"];
                         if([[[arrGames objectAtIndex:k] valueForKey:@"game_type"] isEqualToString:@"individual"])
                             game.gameType = GameTypeIndividual;
                         else
                             game.gameType = GameTypeTeam;
                         
                         game.creator.userID = [[arrGames objectAtIndex:k] valueForKey:@"user_id"];
//                         game.creator.firstName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"first_name"];
//                         game.creator.lastName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"last_name"];
//                         game.creator.email = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"email"];
                         
                         [user.arrayGames addObject:game];
                     }

                     
                     NSArray *arrTeams = [[arrUsers objectAtIndex:i] valueForKey:@"teams"];
                     [user.arrayTeams removeAllObjects];
                     
                     for (int l=0; l < arrTeams.count; l++) {
                         
                         Team *team = [Team new];
                         team.teamID = [[arrTeams objectAtIndex:l] valueForKey:@"id"];
                         team.sportID = [[arrTeams objectAtIndex:l] valueForKey:@"sport_id"];
                         //team.sportName = [[[arrTeams objectAtIndex:l] valueForKey:@"sport"] valueForKey:@"name"];
                         team.teamName = [[arrTeams objectAtIndex:l] valueForKey:@"team_name"];
                         team.memberLimit = [[[arrTeams objectAtIndex:l] valueForKey:@"members_limit"] intValue];
                         team.geoLocation = CLLocationCoordinate2DMake([[[arrTeams objectAtIndex:l] valueForKey:@"latitude"] doubleValue], [[[arrTeams objectAtIndex:l] valueForKey:@"longitude"] doubleValue]);
                         team.address = [[arrTeams objectAtIndex:l] valueForKey:@"address"];
                         if([[[arrTeams objectAtIndex:l] valueForKey:@"team_type"] isEqualToString:@"private"])
                             team.teamType = TeamTypePrivate;
                         else
                             team.teamType = TeamTypeCorporate;
                         
                         team.creator.userID = [[arrTeams objectAtIndex:l] valueForKey:@"creator_id"];
//                         team.creator.firstName = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"first_name"];
//                         team.creator.lastName = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"last_name"];
//                         team.creator.email = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"email"];
                         
                         [user.arrayTeams addObject:team];
                     }

                     [arrayPlayers addObject:user];
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

-(void)searchPlayerWithSearchTerm:(NSString*)searchTerm completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    
    [dictParam setValue:model_manager.profileManager.owner.userID forKey:@"user_id"];
    
    //[dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"is_preferred"];
    
    [dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"is_nearby"];
    
    if(searchTerm)
    {
        [dictParam setValue:searchTerm forKey:@"keyword"];
        [dictParam setValue:[NSNumber numberWithBool:YES] forKey:@"is_keyword"];
    }
    
    [RequestManager asynchronousRequestWithPath:searchPlayersPath requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrUsers = [json valueForKey:@"message"];
                 [arraySearchedPlayers removeAllObjects];
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     User *user = [User new];
                     user.userID = [[arrUsers objectAtIndex:i] valueForKey:@"id"];
                     user.firstName = [[arrUsers objectAtIndex:i] valueForKey:@"first_name"];
                     user.lastName = [[arrUsers objectAtIndex:i] valueForKey:@"last_name"];
                     user.gender = [[arrUsers objectAtIndex:i] valueForKey:@"gender"];
                     user.profilePic = [[arrUsers objectAtIndex:i] valueForKey:@"image"];
                     user.email = [[arrUsers objectAtIndex:i] valueForKey:@"email"];
                     user.dob = [[arrUsers objectAtIndex:i] valueForKey:@"dob"];
                     
                     NSArray *arrSports = [[arrUsers objectAtIndex:i] valueForKey:@"sports_preferences"];
                     [user.arrayPreferredSports removeAllObjects];
                     for (int j=0; j < arrSports.count; j++) {
                         
                         Sport *sport = [Sport new];
                         sport.sportID = [[arrSports objectAtIndex:j] valueForKey:@"sport_id"];
                         //sport.sportName = [[[arrSports objectAtIndex:j] valueForKey:@"Sports"] valueForKey:@"name"];
                         
                         [user.arrayPreferredSports addObject:sport];
                     }
                     
                     NSArray *arrGames = [[arrUsers objectAtIndex:i] valueForKey:@"games"];
                     [user.arrayGames removeAllObjects];
                     
                     for (int k=0; k < arrGames.count; k++) {
                         
                         Game *game = [Game new];
                         game.gameID = [[arrGames objectAtIndex:k] valueForKey:@"id"];
                         game.sportID = [[arrGames objectAtIndex:k] valueForKey:@"sport_id"];
                         //game.sportName = [[[arrGames objectAtIndex:k] valueForKey:@"sport"] valueForKey:@"name"];
                         game.teamID = [[arrGames objectAtIndex:k] valueForKey:@"team_id"];
                         game.date = [[arrGames objectAtIndex:k] valueForKey:@"date"];
                         game.time = [[arrGames objectAtIndex:k] valueForKey:@"time"];
                         game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:k] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:k] valueForKey:@"longitude"] doubleValue]);
                         game.address = [[arrGames objectAtIndex:k] valueForKey:@"address"];
                         if([[[arrGames objectAtIndex:k] valueForKey:@"game_type"] isEqualToString:@"individual"])
                             game.gameType = GameTypeIndividual;
                         else
                             game.gameType = GameTypeTeam;
                         
                         game.creator.userID = [[arrGames objectAtIndex:k] valueForKey:@"user_id"];
                         //                         game.creator.firstName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"first_name"];
                         //                         game.creator.lastName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"last_name"];
                         //                         game.creator.email = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"email"];
                         
                         [user.arrayGames addObject:game];
                     }
                     
                     
                     NSArray *arrTeams = [[arrUsers objectAtIndex:i] valueForKey:@"teams"];
                     [user.arrayTeams removeAllObjects];
                     
                     for (int l=0; l < arrTeams.count; l++) {
                         
                         Team *team = [Team new];
                         team.teamID = [[arrTeams objectAtIndex:l] valueForKey:@"id"];
                         team.sportID = [[arrTeams objectAtIndex:l] valueForKey:@"sport_id"];
                         //team.sportName = [[[arrTeams objectAtIndex:l] valueForKey:@"sport"] valueForKey:@"name"];
                         team.teamName = [[arrTeams objectAtIndex:l] valueForKey:@"team_name"];
                         team.memberLimit = [[[arrTeams objectAtIndex:l] valueForKey:@"members_limit"] intValue];
                         team.geoLocation = CLLocationCoordinate2DMake([[[arrTeams objectAtIndex:l] valueForKey:@"latitude"] doubleValue], [[[arrTeams objectAtIndex:l] valueForKey:@"longitude"] doubleValue]);
                         team.address = [[arrTeams objectAtIndex:l] valueForKey:@"address"];
                         if([[[arrTeams objectAtIndex:l] valueForKey:@"team_type"] isEqualToString:@"private"])
                             team.teamType = TeamTypePrivate;
                         else
                             team.teamType = TeamTypeCorporate;
                         
                         team.creator.userID = [[arrTeams objectAtIndex:l] valueForKey:@"creator_id"];
                         //                         team.creator.firstName = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"first_name"];
                         //                         team.creator.lastName = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"last_name"];
                         //                         team.creator.email = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"email"];
                         
                         [user.arrayTeams addObject:team];
                     }
                     
                     [arraySearchedPlayers addObject:user];
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
    
}

@end
