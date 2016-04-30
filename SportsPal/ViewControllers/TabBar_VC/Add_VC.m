//
//  Add_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#define sportname 1
#define teamname 2
#define date 3
#define time 4
#define address 5

#import "Add_VC.h"


@interface Add_VC ()
{
    __weak IBOutlet UIButton *btnTime;
    __weak IBOutlet UIButton *btnTeamName;
    __weak IBOutlet UIButton *btnAddress;
    __weak IBOutlet UIButton *btnDate;
    __weak IBOutlet UIButton *btnSportName;
}
- (IBAction)clkButton:(id)sender;


@end

@implementation Add_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clkButton:(id)sender {
    
    if (sportname) {
        
    }
    else if (teamname){
        
    }
    else if (date){
        
    }
    else if (time){
        
    }
    else if (address){
        
    }
    
    [self createNewGame];
}

-(void)createNewGame
{
    Game *game = [Game new];
    game.sportID = @"1";
    game.sportName = @"Cricket";
    game.creator = model_manager.profileManager.owner;
    game.gameType = GameTypeIndividual;
    game.geoLocation = kAppDelegate.myLocation.coordinate;
    
    [kAppDelegate.objLoader show];
    
    [model_manager.sportsManager createNewGame:game completion:^(NSDictionary *dictJson, NSError *error) {
        [kAppDelegate.objLoader hide];
        if(!error)
        {
            if([[dictJson valueForKey:@"success"] boolValue])
            {
                //game created successfully
                [self showAlert:[dictJson valueForKey:@"message"]];
            }
            else
            {
                [self showAlert:[dictJson valueForKey:@"message"]];
            }
        }
    }];
}

-(void)showAlert:(NSString *)errorMsg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:errorMsg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             //   [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
}

@end
