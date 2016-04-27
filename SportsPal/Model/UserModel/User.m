
#import "User.h"

@implementation User

@synthesize strUsername,strFirstName,strLastName,strFullName,strUserID,strProfilePic,strGender,strDOB,strEmail;

- (id)init
{
    self = [super init];
    if (self) {
        strUsername = @"";
        strFirstName = @"";
        strLastName = @"";
        strFullName = @"";
        strUserID = @"";
        strProfilePic = @"";
        strGender = @"";
        strDOB = @"";
        strEmail = @"";
    }
    return self;
}

@end
