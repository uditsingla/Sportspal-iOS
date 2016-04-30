
#import "User.h"

@implementation User

@synthesize username,firstName,lastName,fullName,userID,profilePic,gender,dob,email;

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
    }
    return self;
}

@end
