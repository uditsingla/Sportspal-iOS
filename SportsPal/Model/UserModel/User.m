
#import "User.h"
#import "Sport.h"
#import "SVGeocoder.h"


@implementation User

@synthesize username,firstName,lastName,fullName,userID,profilePic,gender,dob,email,bio,arrayPreferredSports,arrayGames,arrayTeams,teamStatus,teamRequestID,gameChallengeID,gameChallengeStatus;

- (id)init
{
    self = [super init];
    if (self) {
        username = @"";
        firstName = @"";
        lastName = @"";
        fullName = @"";
        userID = @"";
        profilePic = @"";
        gender = @"";
        dob = @"";
        email = @"";
        bio = @"";
        teamStatus = NO;
        teamRequestID = @"";
        gameChallengeStatus = NO;
        gameChallengeID = @"";
        arrayPreferredSports = [NSMutableArray new];
        arrayGames = [NSMutableArray new];
        arrayTeams = [NSMutableArray new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // Set primitives
        [copy setUsername:self.username];
        [copy setFirstName:self.firstName];
        [copy setLastName:self.lastName];
        [copy setFullName:self.fullName];
        [copy setProfilePic:self.profilePic];
        [copy setUserID:self.userID];
        [copy setGender:self.gender];
        [copy setDob:self.dob];
        [copy setEmail:self.email];
        [copy setTeamStatus:self.teamStatus];
        [copy setTeamRequestID:self.teamRequestID];
        
        [copy setArrayPreferredSports:self.arrayPreferredSports];
        [copy setArrayGames:self.arrayGames];
        [copy setArrayTeams:self.arrayTeams];
    }
    
    return copy;
}

-(void)getUserDetails:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"users/index/%@",self.userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 self.userID = [NSString stringWithFormat:@"%i", [[[json valueForKey:@"message"] valueForKey:@"id"] intValue]];
                 self.firstName = [[json valueForKey:@"message"] valueForKey:@"first_name"];
                 self.lastName = [[json valueForKey:@"message"] valueForKey:@"last_name"];
                 self.gender = [[json valueForKey:@"message"] valueForKey:@"gender"];
                 self.profilePic = [[json valueForKey:@"message"] valueForKey:@"image"];
                 self.email = [[json valueForKey:@"message"] valueForKey:@"email"];
                 self.dob = [[json valueForKey:@"message"] valueForKey:@"dob"];
                 self.bio = [[json valueForKey:@"message"] valueForKey:@"bio"];
                 
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
                 
                 NSArray *arrSports = [[json valueForKey:@"message"] valueForKey:@"sports_preferences"];
                 if(arrSports.count>0)
                     [self.arrayPreferredSports removeAllObjects];
                 for (int j=0; j < arrSports.count; j++) {
                     
                     Sport *sport = [Sport new];
                     sport.sportID = [NSString stringWithFormat:@"%i",[[[arrSports objectAtIndex:j] valueForKey:@"sport_id"] intValue]];
                     sport.sportName = [[[arrSports objectAtIndex:j] valueForKey:@"sport"] valueForKey:@"name"];
                     
                     [self.arrayPreferredSports addObject:sport];
                 }
                 
                 NSArray *arrGames = [[json valueForKey:@"message"] valueForKey:@"games"];
                 if(arrGames.count>0)
                     [self.arrayGames removeAllObjects];
                 
                 for (int k=0; k < arrGames.count; k++) {
                     
                     Game *game = [Game new];
                     game.gameID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"id"] intValue]];
                     game.sportID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"sport_id"] intValue]];
                     game.sportName = [[[arrGames objectAtIndex:k] valueForKey:@"sport"] valueForKey:@"name"];
                     game.gameName = [[arrGames objectAtIndex:k] valueForKey:@"name"];
                     game.teamID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"team_id"] intValue]];
                     game.date = [[arrGames objectAtIndex:k] valueForKey:@"date"];
                     game.time = [[arrGames objectAtIndex:k] valueForKey:@"time"];
                     if([[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"]!=nil && ![[[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"] isEqual:[NSNull null]])
                         game.teamName = [[[arrGames objectAtIndex:k] valueForKey:@"team"] valueForKey:@"team_name"];
                     game.distance = [NSString stringWithFormat:@"%.0fkm",[[[arrGames objectAtIndex:k] valueForKey:@"distance"] floatValue]];
                     
                     game.geoLocation = CLLocationCoordinate2DMake([[[arrGames objectAtIndex:k] valueForKey:@"latitude"] doubleValue], [[[arrGames objectAtIndex:k] valueForKey:@"longitude"] doubleValue]);
                     game.address = [[arrGames objectAtIndex:k] valueForKey:@"address"];
                     if([[[arrGames objectAtIndex:k] valueForKey:@"game_type"] isEqualToString:@"individual"])
                         game.gameType = GameTypeIndividual;
                     else
                         game.gameType = GameTypeTeam;
                     
                     game.gameCategory = [[arrGames objectAtIndex:k] valueForKey:@"game_status"];
                     game.membersLimit = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"member_limit"] intValue]];
                     
                     game.creator.userID = [NSString stringWithFormat:@"%i",[[[arrGames objectAtIndex:k] valueForKey:@"user_id"] intValue]];
                      game.creator.firstName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"first_name"];
                      game.creator.lastName = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"last_name"];
                      game.creator.email = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"email"];
                     game.creator.profilePic = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"image"];
                     game.creator.dob = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"dob"];

                     NSArray *arrSports = [[[arrGames objectAtIndex:k] valueForKey:@"user"] valueForKey:@"sports_preferences"];
                     if(arrSports.count>0)
                         [game.creator.arrayPreferredSports removeAllObjects];
                     for (int j=0; j < arrSports.count; j++) {
                         
                         Sport *sport = [Sport new];
                         sport.sportID = [NSString stringWithFormat:@"%i",[[[arrSports objectAtIndex:j] valueForKey:@"sport_id"] intValue]];
                         sport.sportName = [[[arrSports objectAtIndex:j] valueForKey:@"sport"] valueForKey:@"name"];
                         
                         [game.creator.arrayPreferredSports addObject:sport];
                     }
                     
                     [self.arrayGames addObject:game];
                 }
                 
                 
                 NSArray *arrTeams = [[json valueForKey:@"message"] valueForKey:@"teams"];
                 if(arrTeams.count>0)
                     [self.arrayTeams removeAllObjects];
                 
                 for (int l=0; l < arrTeams.count; l++) {
                     
                     Team *team = [Team new];
                     team.teamID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:l] valueForKey:@"id"] intValue]];
                     team.sportID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:l] valueForKey:@"sport_id"] intValue]];
                     //team.sportName = [[[arrTeams objectAtIndex:l] valueForKey:@"sport"] valueForKey:@"name"];
                     team.teamName = [[arrTeams objectAtIndex:l] valueForKey:@"team_name"];
                     team.memberLimit = [[[arrTeams objectAtIndex:l] valueForKey:@"members_limit"] intValue];
                     team.geoLocation = CLLocationCoordinate2DMake([[[arrTeams objectAtIndex:l] valueForKey:@"latitude"] doubleValue], [[[arrTeams objectAtIndex:l] valueForKey:@"longitude"] doubleValue]);
                     team.address = [[arrTeams objectAtIndex:l] valueForKey:@"address"];
                     if([[[arrTeams objectAtIndex:l] valueForKey:@"team_type"] isEqualToString:@"private"])
                         team.teamType = TeamTypePrivate;
                     else
                         team.teamType = TeamTypeCorporate;
                     
                     team.creator.userID = [NSString stringWithFormat:@"%i",[[[arrTeams objectAtIndex:l] valueForKey:@"creator_id"] intValue]];
                     //                         team.creator.firstName = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"first_name"];
                     //                         team.creator.lastName = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"last_name"];
                     //                         team.creator.email = [[[arrTeams objectAtIndex:l] valueForKey:@"user"] valueForKey:@"email"];
                     
                     [self.arrayTeams addObject:team];
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

-(void)updateUserDetails:(NSDictionary*)dictParam completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"users/index/%@",self.userID] requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 self.firstName = [dictParam valueForKey:@"first_name"];
                 self.lastName = [dictParam valueForKey:@"last_name"];
                 self.email = [dictParam valueForKey:@"email"];
                 self.dob = [dictParam valueForKey:@"dob"];
                 self.gender = [dictParam valueForKey:@"gender"];
                 self.bio = [dictParam valueForKey:@"bio"];
                 
                 [model_manager.profileManager.owner getUserDetails:nil];
             }
             
             if(completionBlock)
                 completionBlock(json,nil);
         }
         else if(completionBlock)
             completionBlock(nil,nil);
         
         NSLog(@"Here comes the json %@",json);
     } ];
}

-(void)getPreferredSports:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"users/sports/%@",userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrSports = [json valueForKey:@"message"];
                 [arrayPreferredSports removeAllObjects];
                 
                 for (int i=0; i < arrSports.count; i++) {
                     
                     Sport *sport = [Sport new];
                     sport.sportID = [NSString stringWithFormat:@"%i",[[[arrSports objectAtIndex:i] valueForKey:@"sport_id"] intValue]];
                     sport.sportName = [[[arrSports objectAtIndex:i] valueForKey:@"Sports"] valueForKey:@"name"];
                     
                     [arrayPreferredSports addObject:sport];
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

-(void)addPreferredSports:(NSArray*)arraySports :(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    NSMutableArray *sportIDs = [NSMutableArray new];
    for (Sport *sport in arraySports) {
        [sportIDs addObject:sport.sportID];
    }
    
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"user_id", sportIDs,@"sport_id", nil];
    
    [RequestManager asynchronousRequestWithPath:@"users/sports" requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:YES onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 [arrayPreferredSports removeAllObjects];
                 [arrayPreferredSports addObjectsFromArray:arraySports];
                 
                 [model_manager.profileManager.owner.arrayPreferredSports removeAllObjects];
                 [model_manager.profileManager.owner.arrayPreferredSports addObjectsFromArray:arraySports];
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
