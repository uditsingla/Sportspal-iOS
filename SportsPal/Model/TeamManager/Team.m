//
//  Team.m
//  SportsPal
//
//  Created by Arun Jumwal on 5/1/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize teamID,sportID,sportName,teamName,memberLimit,geoLocation,address,teamType,creator,arrayMembers;

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
        creator = [User new];
        
        arrayMembers = [NSMutableArray new];
    }
    return self;
}

-(void)getTeamDetails:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"teams/singleteam/%@",self.teamID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
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
                 
                 self.creator.userID = [[json valueForKey:@"message"] valueForKey:@"creator_id"];
                 self.creator.firstName = [[[json valueForKey:@"message"] valueForKey:@"user"] valueForKey:@"first_name"];
                 self.creator.lastName = [[[json valueForKey:@"message"] valueForKey:@"user"] valueForKey:@"last_name"];
                 self.creator.email = [[[json valueForKey:@"message"] valueForKey:@"user"] valueForKey:@"email"];
                 
                 NSArray *arrUsers = [[json valueForKey:@"message"] valueForKey:@"team_members"];
                 [arrayMembers removeAllObjects];
                 
                 for (int i=0; i < arrUsers.count; i++) {
                     
                     User *user = [User new];
                     user.userID = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"user_id"];
                     user.firstName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"first_name"];
                     user.lastName = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"last_name"];
                     user.gender = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"gender"];
                     user.profilePic = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"image"];
                     user.email = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"email"];
                     user.dob = [[[arrUsers objectAtIndex:i] valueForKey:@"user"] valueForKey:@"dob"];
                     
                     
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


@end
