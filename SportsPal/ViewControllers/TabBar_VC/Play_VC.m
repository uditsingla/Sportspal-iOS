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
#import "AFHTTPRequestOperationManager.h"

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
    
    //arrPlayers = [NSMutableArray arrayWithObjects:@"Player 1 ",@"Player 2",@"Player 3",@"Player 4", nil];
    arrPlayers = model_manager.playerManager.arrayPlayers;
    
    //arrSports = [NSMutableArray arrayWithObjects:@"Sports 1 ",@"Sports 2",@"Sports 3",@"Sports 4", nil];
    arrSports = model_manager.sportsManager.arrayGames;
    
    //arrTeams =[NSMutableArray arrayWithObjects:@"Team 1 ",@"Team 2",@"Team 3",@"Team 4", nil];
    arrTeams = model_manager.teamManager.arrayTeams;
    
    arrSearchResult = [NSMutableArray new];
    arrTempSearch = [NSMutableArray new];
    
    [self hideAllViews];
    lblPlay.hidden = NO;
    
    tblPlayers.hidden = NO;
    
    manager = [AFHTTPRequestOperationManager manager];
    
    [super viewDidLoad];
    
    searchbar.barTintColor = DullGreen;

    txfSearchField = [searchbar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor blackColor];
    txfSearchField.textColor = [UIColor whiteColor];
    
//    searchbar.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"isLocation"];

    [tblSports reloadData];
    [tblPlayers reloadData];
    [tblTeams reloadData];
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
        cell.lblName.text = game.sportName;
        
        NSLog(@"Game name : %@",game.sportName);
       // cell.lblName.textColor = [UIColor whiteColor];
        
        //NSLog(@"time : %@, %@",game.time,game.date);
        cell.lblGame1.text = game.time;
        cell.lblGame2.text = game.date;
        
        cell.imgBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",game.sportName]];
        
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
        
        

//        cell.imgBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[player.arrayPreferredSports objectAtIndex:0]]];

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
        
        cell.lblGame1.text = team.sportName;
        
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
        
    }
    else if (theTableView == tblTeams)
    {
        
    }
    else if (theTableView == tblSports)
    {
        
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
