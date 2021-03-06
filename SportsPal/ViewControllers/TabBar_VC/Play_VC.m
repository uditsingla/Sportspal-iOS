//
//  Play_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Play_VC.h"
#import "TB_Play_Players.h"
#import "TB_Play_Sports.h"
#import "TB_Play_Teams.h"
#import "Game.h"
#import "Sport.h"
#import "AFHTTPRequestOperationManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Profile_VC.h"
#import "AddTeam.h"
#import "Add_VC.h"

@interface Play_VC ()
{
    NSMutableArray *arrPlayers,*arrSports,*arrTeams,*arrSearchResult,*arrTempSearch;
    
    __weak IBOutlet UITableView *tblPlayers;
    __weak IBOutlet UITableView *tblSports;
    __weak IBOutlet UITableView *tblTeams;
    __weak IBOutlet UITableView *tblSearch;
    
    __weak IBOutlet UISegmentedControl *segmentedcontrol;
    __weak IBOutlet UISearchBar *searchbar;
    
    
    __weak IBOutlet UILabel *lblPlay;
    __weak IBOutlet UIButton *btnSearch;
    __weak IBOutlet UIButton *btnMenu;
    
    
    UITextField *txfSearchField;
    
    AFHTTPRequestOperation *postAutoComplete;
    AFHTTPRequestOperationManager *manager;
}
- (IBAction)clkSearch:(id)sender;
- (IBAction)clkSegment:(UISegmentedControl*)sender;
- (IBAction)clkNotifications:(id)sender;
- (IBAction)clkSlider:(id)sender;

@end

@implementation Play_VC

- (void)viewDidLoad
{
    //Segmented Controll
    
    [segmentedcontrol addTarget:self
                         action:@selector(clkSegment:)
               forControlEvents:UIControlEventValueChanged];
    
    model_manager.sportsManager.sportsManagerDelegate = self;
    model_manager.teamManager.teamManagerDelegate = self;
    

    arrPlayers = model_manager.playerManager.arrayPlayers;
    
   
    arrSports = model_manager.sportsManager.arrayGames;
    

    arrTeams = model_manager.teamManager.arrayTeams;
    
    arrSearchResult = [NSMutableArray new];
    arrTempSearch = [NSMutableArray new];
    
    [self hideAllViews];
    lblPlay.hidden = NO;
    
    tblPlayers.hidden = NO;
    
    manager = [AFHTTPRequestOperationManager manager];
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kBlackColor;
    
    tblPlayers.backgroundColor = kBlackColor;
    tblSports.backgroundColor = kBlackColor;
    tblTeams.backgroundColor = kBlackColor;

    //SearchBar UI
    searchbar.barTintColor = kBlackColor;
    txfSearchField = [searchbar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor blackColor];
    txfSearchField.textColor = [UIColor whiteColor];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor grayColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  nil,
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                                                                  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    
    //segmentedcontrol.tintColor = [UIColor colorWithRed:139/255.00 green:195/255.00 blue:74/255.00 alpha:1];
//    searchbar.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    
    segmentedcontrol.selectedSegmentIndex = 0;
    //searchbar.tintColor = [UIColor whiteColor];

}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"isLocation"];

    [tblSports reloadData];
    [tblPlayers reloadData];
    [tblTeams reloadData];
    
    [model_manager.playerManager getNearByUsers:^(NSDictionary *dictJson, NSError *error) {
        [tblPlayers reloadData];
    }];
    [model_manager.sportsManager getAvailableGames:^(NSDictionary *dictJson, NSError *error) {
        [tblSports reloadData];
    }];
    [model_manager.teamManager getAvailableTeams:^(NSDictionary *dictJson, NSError *error) {
        [tblTeams reloadData];
    }];
    
    
    [segmentedcontrol sendActionsForControlEvents:UIControlEventValueChanged];

}

-(void)newGameCreated:(Game *)game
{
    segmentedcontrol.selectedSegmentIndex = 0;
    [tblSports setContentOffset:CGPointZero animated:YES];

}

-(void)newTeamCreated:(Team *)team
{
    segmentedcontrol.selectedSegmentIndex = 2;
    [tblTeams setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetViews
{
    searchbar.hidden = YES;
    btnSearch.hidden = NO;
    lblPlay.hidden = NO;
    btnMenu.hidden = NO;

}

#pragma mark - custom methods
- (IBAction)clkSearch:(id)sender {
    
    searchbar.hidden = NO;
    btnSearch.hidden = YES;
    lblPlay.hidden = YES;
    btnMenu.hidden = YES;
    
    [searchbar becomeFirstResponder];
}

- (IBAction)clkSegment:(UISegmentedControl*)sender
{
    [self hideAllViews];
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        [self resetViews];
        tblSports.hidden = NO;
        [tblSports reloadData];
    }
    else if (selectedSegment == 1)
    {
        [self resetViews];
        tblPlayers.hidden = NO;
        [tblPlayers reloadData];
    }
    else
    {
        [self resetViews];
        tblTeams.hidden = NO;
        [tblTeams reloadData];
    }
}

-(void)hideAllViews
{
    tblSports.hidden = YES;
    tblPlayers.hidden = YES;
    tblTeams.hidden = YES;
    tblSearch.hidden = YES;
    searchbar.hidden = YES;
    txfSearchField.text = @"";
    [txfSearchField resignFirstResponder];
}

- (IBAction)clkNotifications:(id)sender
{
    
}

- (IBAction)clkSlider:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

-(void)showAlert:(NSString *)errorMsg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Delegates and Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (tableView == tblSports) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        TB_Play_Sports *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[TB_Play_Sports alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        Game *game = [arrSports objectAtIndex:indexPath.row];
        
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.lblGameName.text = game.gameName;
        cell.lblName.text = game.sportName;
        cell.lblSkillLevel.text = game.distance;
        
        
       // cell.lblName.textColor = [UIColor whiteColor];
        
        //NSLog(@"time : %@, %@",game.time,game.date);
        cell.lblGame1.text = game.time;
        cell.lblGame2.text = game.date;
        NSLog(@"Game name : %@",game.sportName);
        
        NSString *strGameImage = [game.sportName lowercaseString];

        cell.imgBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strGameImage]];
        
        if([game.creator.userID isEqualToString:model_manager.profileManager.owner.userID])
            cell.imgIsAdmin.hidden = NO;
        else
            cell.imgIsAdmin.hidden = YES;
        
        return cell;

    }
    
    else if (tableView == tblPlayers) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        TB_Play_Players *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[TB_Play_Players alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        User *player = [arrPlayers objectAtIndex:indexPath.row];
        
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.lblName.text = [NSString stringWithFormat:@"%@ %@",[player.firstName uppercaseString],[player.lastName uppercaseString]];
        cell.lblName.textColor = [UIColor whiteColor];
        
        cell.lblSkillLevel.text = @"Expert";
        if(player.arrayPreferredSports.count>0)
        {
            
            
            NSString *strSportImage = ((Sport*)[player.arrayPreferredSports objectAtIndex:0]).sportName;
            if(![strSportImage isEqual:[NSNull null]])
            strSportImage = [strSportImage lowercaseString];
            
            
            NSLog(@"Sport name :  %@",strSportImage);
            
            cell.imgBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strSportImage]];
            if(player.arrayPreferredSports.count>1)
            {
                cell.lblGame1.text = [NSString stringWithFormat:@"#%@",((Sport*)[player.arrayPreferredSports objectAtIndex:0]).sportName];
                cell.lblGame2.text = [NSString stringWithFormat:@"#%@",((Sport*)[player.arrayPreferredSports objectAtIndex:1]).sportName];
            }
            else
            {
                cell.lblGame1.text = @"";
                cell.lblGame2.text = [NSString stringWithFormat:@"#%@",((Sport*)[player.arrayPreferredSports objectAtIndex:0]).sportName];
            }
        }
        else
        {
            cell.imgBackground.image = [UIImage imageNamed:@"rockclimbing.png"];
            cell.lblGame1.text = @"";
            cell.lblGame2.text = @"";
        }
        
        if(player.profilePic.length>0)
            [cell.imgBackground sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrlPath,player.profilePic]] placeholderImage:[UIImage imageNamed:@"members.png"]];

        return cell;

    }
    
    else if (tableView == tblTeams) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        TB_Play_Teams *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[TB_Play_Teams alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        Team *team = [arrTeams objectAtIndex:indexPath.row];
        
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.lblName.text = team.teamName;
        cell.lblName.textColor = [UIColor whiteColor];
        
        NSLog(@"sport name...%@",team.sportName);
        if(![team.sportName isEqual:[NSNull null]])
        {
            cell.lblGame1.text = team.sportName;
            
            NSString *strTeamSportImage = [team.sportName lowercaseString];
            
            if(strTeamSportImage)
                cell.imgBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strTeamSportImage]];

        }
        
        if([team.address isEqual:[NSNull null]])
            cell.lblGame2.text = team.address;
        
        if([team.creator.userID isEqualToString:model_manager.profileManager.owner.userID])
            cell.imgIsAdmin.hidden = NO;
        else
            cell.imgIsAdmin.hidden = YES;
        
        return cell;

    }
    
    else if (tableView == tblSearch) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.textLabel.text = [arrSearchResult objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        tblSearch.backgroundColor = [UIColor blackColor];
        return cell;

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (theTableView == tblPlayers)
    {
        return [arrPlayers count];
    }
    else if (theTableView == tblTeams)
    {
        return [arrTeams count];
    }
    else if (theTableView == tblSports)
    {
        return [arrSports count];
    }
    else if (theTableView == tblSearch)
    {
        return [arrSearchResult count];
    }
    
    return [arrPlayers count];
    
}




#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
    if (theTableView == tblPlayers)
    {
        Profile_VC *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"profile_vc"];
        viewcontroller.user = (User*)[arrPlayers objectAtIndex:indexPath.row];
        [kAppDelegate.container.centerViewController pushViewController:viewcontroller animated:YES];
    }
    else if (theTableView == tblTeams)
    {
        AddTeam *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"addteam"];
        viewcontroller.selectedTeam = (Team*)[arrTeams objectAtIndex:indexPath.row];
        [kAppDelegate.container.centerViewController pushViewController:viewcontroller animated:YES];
    }
    else if (theTableView == tblSports)
    {
        Add_VC *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"add_vc"];
        viewcontroller.selectedGame = (Game*)[arrSports objectAtIndex:indexPath.row];
        [kAppDelegate.container.centerViewController pushViewController:viewcontroller animated:YES];

    }
    else if (theTableView == tblSearch)
    {
        if(segmentedcontrol.selectedSegmentIndex==0)
        {
            //search games

        }
        else if(segmentedcontrol.selectedSegmentIndex==1)
        {
            //search players
            
        }
        else if(segmentedcontrol.selectedSegmentIndex==2)
        {
            //search teams
            
        }
    }
}


#pragma mark - Searchbar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        tblSearch.hidden = YES;
        [arrSearchResult removeAllObjects];
        [tblSearch reloadData];
    }
    
//    if(postAutoComplete)
//        [postAutoComplete cancel];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:model_manager.profileManager.owner.userID,@"user_id",searchText,@"search_term",nil];
//    
//    postAutoComplete = [manager POST:[NSString stringWithFormat:@"%@games/getAutoFill",kBaseUrlPath] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //doing something
//        if(((NSArray*)responseObject).count>0 && [searchBar isFirstResponder])
//        {
//            tblSearch.hidden = NO;
//            [arrSearchResult removeAllObjects];
//            [arrSearchResult addObjectsFromArray:(NSArray*)responseObject];
//            
//            [tblSearch reloadData];
//        }
//        else
//        {
//            tblSearch.hidden = YES;
//            [arrSearchResult removeAllObjects];
//            [tblSearch reloadData];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // error handling.
//    }];


}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if(segmentedcontrol.selectedSegmentIndex==0)
    {
        //search games
        if(searchBar.text.length>0)
        {
            [kAppDelegate.objLoader show];
            [model_manager.sportsManager searchGameWithSearchTerm:searchBar.text completion:^(NSDictionary *dictJson, NSError *error) {
                
                [kAppDelegate.objLoader hide];
                if(!error)
                {
                    if([[dictJson valueForKey:@"success"] boolValue])
                    {
                        if(model_manager.sportsManager.arraySearchedGames.count>0)
                            arrSports = model_manager.sportsManager.arraySearchedGames;
                        [tblSports reloadData];
                    }
                    else
                    {
                        [self showAlert:[dictJson valueForKey:@"message"]];
                    }
                }
            }];
        }
        else
        {
            arrSports = model_manager.sportsManager.arrayGames;
            [tblSports reloadData];
        }
        
    }
    else if(segmentedcontrol.selectedSegmentIndex==1)
    {
        //search players
        if(searchBar.text.length>0)
        {
            [kAppDelegate.objLoader show];
            [model_manager.playerManager searchPlayerWithSearchTerm:searchBar.text completion:^(NSDictionary *dictJson, NSError *error)
             {
                 
                 [kAppDelegate.objLoader hide];
                 if(!error)
                 {
                     if([[dictJson valueForKey:@"success"] boolValue])
                     {
                         if(model_manager.playerManager.arraySearchedPlayers.count>0)
                             arrPlayers = model_manager.playerManager.arraySearchedPlayers;
                         [tblPlayers reloadData];
                     }
                     else
                     {
                         [self showAlert:[dictJson valueForKey:@"message"]];
                     }
                 }
             }];
        }
        else
        {
            arrPlayers = model_manager.playerManager.arrayPlayers;
            [tblPlayers reloadData];
        }
        
    }
    else if(segmentedcontrol.selectedSegmentIndex==2)
    {
        //search teams
        if(searchBar.text.length>0)
        {
            [kAppDelegate.objLoader show];
            [model_manager.teamManager searchTeamWithSearchTerm:searchBar.text completion:^(NSDictionary *dictJson, NSError *error)
            {
                
                [kAppDelegate.objLoader hide];
                if(!error)
                {
                    if([[dictJson valueForKey:@"success"] boolValue])
                    {
                        if(model_manager.teamManager.arraySearchedTeams.count>0)
                            arrTeams = model_manager.teamManager.arraySearchedTeams;
                        [tblTeams reloadData];
                    }
                    else
                    {
                        [self showAlert:[dictJson valueForKey:@"message"]];
                    }
                }
            }];
        }
        else
        {
            arrTeams = model_manager.teamManager.arrayTeams;
            [tblTeams reloadData];
        }

    }
    
}


-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
//        tblSearch.hidden = NO;
        [tblSearch reloadData];
        [searchBar resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    tblSearch.hidden = YES;
    searchbar.text = @"";
    searchbar.hidden = YES;
    btnSearch.hidden = NO;
    btnMenu.hidden = NO;
    lblPlay.hidden = NO;
    [searchbar resignFirstResponder];
}


@end
