//
//  Game.m
//  SportsPal
//
//  Created by Arun Jumwal on 4/30/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize gameID,gameName,sportID,sportName,teamID,date,time,geoLocation,address,gameType,creator,distance,arrayChallenges;

- (id)init
{
    self = [super init];
    if (self) {
        gameID = @"";
        gameName = @"";
        sportID = @"";
        sportName = @"";
        teamID = @"";
        date = @"";
        time = @"";
        geoLocation = CLLocationCoordinate2DMake(0, 0);
        address = @"";
        distance = @"";
        gameType = GameTypeIndividual;
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
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     User *user = [User new];
                     user.userID = [NSString stringWithFormat:@"%i", [[[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"id"] intValue]];
                     user.firstName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     user.lastName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     user.gender = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"gender"];
                     user.profilePic = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                     user.email = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     user.dob = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                     
                     user.gameChallengeStatus = [[[arrUsers objectAtIndex:i] valueForKey:@"status"] boolValue];
                     user.gameChallengeID = [[arrUsers objectAtIndex:i] valueForKey:@"id"];
                     [arrayChallenges addObject:user];
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



@end
