
#import "User.h"
#import "Sport.h"

@implementation User

@synthesize username,firstName,lastName,fullName,userID,profilePic,gender,dob,email,arrayPreferredSports;

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
        arrayPreferredSports = [NSMutableArray new];
    }
    return self;
}

-(void)getPreferredSports:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock
{
    [RequestManager asynchronousRequestWithPath:[NSString stringWithFormat:@"users/sports/%@",userID] requestType:RequestTypeGET params:nil timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                 NSArray *arrSports = [json valueForKey:@"message"];
                 [arrayPreferredSports removeAllObjects];
                 
                 for (int i=0; i < arrSports.count; i++) {
                     
                     Sport *sport = [Sport new];
                     sport.sportID = [[arrSports objectAtIndex:i] valueForKey:@"sport_id"];
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
    
    [RequestManager asynchronousRequestWithPath:@"users/sports" requestType:RequestTypePOST params:dictParam timeOut:60 includeHeaders:NO onCompletion:^(long statusCode, NSDictionary *json)
     {
         
         if(statusCode==200)
         {
             if([[json valueForKey:@"success"] boolValue])
             {
                [arrayPreferredSports addObjectsFromArray:arraySports];
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
