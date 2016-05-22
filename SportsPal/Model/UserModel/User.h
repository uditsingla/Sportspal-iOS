

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCopying>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, assign) BOOL teamStatus;
@property (nonatomic, strong) NSString *teamRequestID;
@property (nonatomic, strong) NSMutableArray *arrayPreferredSports;

@property (nonatomic, strong) NSMutableArray *arrayGames;
@property (nonatomic, strong) NSMutableArray *arrayTeams;

-(void)getUserDetails:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)updateUserDetails:(NSDictionary*)dictParam completion:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)getPreferredSports:(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

-(void)addPreferredSports:(NSArray*)arraySports :(void(^)(NSDictionary *dictJson, NSError *error))completionBlock;

@end
