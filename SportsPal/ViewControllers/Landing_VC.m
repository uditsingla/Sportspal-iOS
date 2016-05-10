//
//  Landing_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 15/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Landing_VC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface Landing_VC ()
{
    __weak IBOutlet UIImageView *imgBackground;
    NSArray *myImages;
    NSTimer *updateBCK;
}
@end

@implementation Landing_VC

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
    
    myImages=[NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",nil];
    
    updateBCK = [NSTimer scheduledTimerWithTimeInterval:(2.0) target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    
    [updateBCK fire];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLogin"])
    {
        UIViewController *homeVC = [kMainStoryboard instantiateInitialViewController];
        [self.navigationController pushViewController:homeVC animated:NO];
        
        [model_manager.playerManager getNearByUsers:nil];
        [model_manager.sportsManager getAvailableGames:nil];
        [model_manager.teamManager getAvailableTeams:nil];
        [model_manager.profileManager.owner getUserDetails:nil];
        [model_manager.profileManager.owner getPreferredSports:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Click Methods

- (IBAction)clk_FBlogin:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in result : %@",result);
             
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 NSLog(@"result is:%@",result.grantedPermissions);
                 [self fetchUserInfo];
             }
         }
     }];
}

- (IBAction)clkLogin:(id)sender
{
//    UIViewController *homeVC = [kMainStoryboard instantiateInitialViewController];
//    [self.navigationController pushViewController:homeVC animated:YES];
}
- (IBAction)clkSignUp:(id)sender
{
    
}

#pragma mark - Custom Methods


-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}

-(void)changeImage
{
    static int i=0;
    
    if (i == [myImages count]){
        i=0;
    }
    
    
    [UIView transitionWithView:imgBackground
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imgBackground.image = [UIImage imageNamed:[myImages objectAtIndex:i]];
                        i++;
                        
                    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
