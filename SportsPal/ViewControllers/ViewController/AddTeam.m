//
//  AddTeam.m
//  SportsPal
//
//  Created by Abhishek Singla on 01/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#define sportname 1
#define teamname 2
#define teamtype 3
#define teamsize 4

#import "AddTeam.h"
#import "Add_VC.h"

#import "Sport.h"
#import "TB_AddTeam.h"
#import "Team.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface AddTeam ()
{
    __weak IBOutlet UIPickerView *pickerSports;
    __weak IBOutlet UIPickerView *pickerType;
    
    __weak IBOutlet UIButton *btnSportName;
    __weak IBOutlet UIButton *btnTeamName;
    __weak IBOutlet UIButton *btnTeamType;
    
    __weak IBOutlet UILabel *lblteamCurrentMembers;


    
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UITableView *tblTeam;
    
    NSString *strSportName,*strSportID,*strTeamname,*strTeamType;
    int teamSize;
    
    int pickerselected;
    UIToolbar *toolBar;
    
    __weak IBOutlet UISegmentedControl *segmentcotrol;
    
    NSArray *arraySportsType;
    
    NSMutableArray *arrTeamPlayers,*arrSearchResult;
    
    NSMutableArray *arrayPrefferedSportsUsers;
    
    
    __weak IBOutlet NSLayoutConstraint *contentviewHeight;
    
    __weak IBOutlet UIView *toolBarSuperView;
    
    __weak IBOutlet UIImageView *imgSelectedImage;
    
    __weak IBOutlet UISearchBar *searchbar;
    
    __weak IBOutlet UITableView *tblSearchResult;
    
    
    __weak IBOutlet UIButton *btnMenu;
    __weak IBOutlet UILabel *lblTittle;
    __weak IBOutlet UIButton *btnSave;
   
    UITextField *txfSearchField;
    
    
}
- (IBAction)clkSlider:(id)sender;

- (IBAction)clkButton:(id)sender;

- (IBAction)clkSegment:(UISegmentedControl*)sender;

@end

@implementation AddTeam

@synthesize selectedTeam;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tblTeam.dataSource = self;
    tblTeam.delegate = self;
    
    tblSearchResult.dataSource = self;
    tblSearchResult.delegate = self;
    
    self.view.backgroundColor = kBlackColor;
    tblTeam.backgroundColor = kBlackColor;
    
    //
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(clkDone:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [toolBarSuperView addSubview:toolBar];
    //
    
    [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor =[UIColor colorWithWhite:1 alpha:0];
    

    
    [segmentcotrol addTarget:self
                      action:@selector(clkSegment:)
            forControlEvents:UIControlEventValueChanged];
    
    [segmentcotrol setSelectedSegmentIndex:1];
    
    
    [self hideAllPickers];
    
    arraySportsType = [NSArray arrayWithObjects:@"Corporate",@"Private", nil];
    
    
    
    scrollview.backgroundColor = [UIColor clearColor];
    
    arrTeamPlayers = [NSMutableArray new];
    arrSearchResult = [NSMutableArray new];
    
//    [arrTeamPlayers addObject:@"Sachin"];
//    [arrTeamPlayers addObject:@"Abhi"];
//    [arrTeamPlayers addObject:@"Rohit"];
//    [arrTeamPlayers addObject:@"Sachin"];
//    [arrTeamPlayers addObject:@"Abhi"];
//    [arrTeamPlayers addObject:@"Rohit"];
//    [arrTeamPlayers addObject:@"Sachin"];

    
    NSLog(@"scroll content height %f",scrollview.contentSize.height);
    
    int heightContent = ((int)arrTeamPlayers.count+1)*44;
    contentviewHeight.constant = 185+heightContent;
    
    //contentviewHeight.constant = 2000;
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *myItem = [tabBar.items objectAtIndex:2];
    
    [myItem initWithTitle:@"ADD" image:[UIImage imageNamed:@"add.png"] selectedImage:[UIImage imageNamed:@"add.png"]];
    
    imgSelectedImage.hidden = YES;
    
    if(selectedTeam)
    {
        [btnMenu setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        lblTittle.text = @"TEAM DETAILS";
        btnSave.hidden = YES;
        segmentcotrol.hidden = YES;
        imgSelectedImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[selectedTeam.sportName lowercaseString]]];
        imgSelectedImage.hidden = NO;
        btnSportName.enabled = NO;
        [btnSportName setTitle:selectedTeam.sportName forState:UIControlStateNormal];
        btnTeamName.enabled = NO;
        [btnTeamName setTitle:selectedTeam.teamName forState:UIControlStateNormal];
        NSString *team_type;
        if(selectedTeam.teamType==TeamTypeCorporate)
            team_type = @"Corporate";
        else
            team_type = @"Private";
        [btnTeamType setTitle:team_type forState:UIControlStateNormal];
        btnTeamType.enabled = NO;
        
        strSportID = selectedTeam.sportID;
        strSportName = selectedTeam.sportName;
        strTeamType = team_type;
        strTeamname = selectedTeam.teamName;
        teamSize = 0;
        
        [selectedTeam getTeamDetails:^(NSDictionary *dictJson, NSError *error) {
            if(!error)
            {
                if([[dictJson valueForKey:@"success"] boolValue])
                {
                    [arrTeamPlayers addObjectsFromArray:selectedTeam.arrayMembers];
                    int heightContent = ((int)arrTeamPlayers.count+1)*44;
                    contentviewHeight.constant = 185+heightContent;
                    [tblTeam reloadData];
                    
                    lblteamCurrentMembers.text = [NSString stringWithFormat:@"MEMBERS (%lu)",(unsigned long)arrTeamPlayers.count];
                }
                else
                {
                    [self showAlert:[dictJson valueForKey:@"message"]];
                }
            }
        }];
    }
    
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

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(selectedTeam==nil)
    {
        [arrTeamPlayers removeAllObjects];
        [tblTeam reloadData];
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"isLocation"];

   // NSLog(@"%@",self.navigationController.viewControllers);
//    self.tabBarController.tabBar.hidden = NO;
//    self.hidesBottomBarWhenPushed = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self hideAllPickers];
    [self resetAllContent];
    [arrTeamPlayers removeAllObjects];
    [tblTeam reloadData];
}

-(void)createNewTeam
{
    Team *team = [Team new];
    team.sportID = strSportID;
    team.sportName = strSportName;
    team.creator = model_manager.profileManager.owner;
    if([strTeamType isEqualToString:@"Private"])
        team.teamType = TeamTypePrivate;
    else if([strTeamType isEqualToString:@"Corporate"])
        team.teamType = TeamTypeCorporate;
    else
        team.teamType = TeamTypePrivate;
    team.teamName = strTeamname;
    team.memberLimit = teamSize;
    team.arrayMembers = arrTeamPlayers;
    
    
    [kAppDelegate.objLoader show];
    
    [model_manager.teamManager createNewTeam:team completion:^(NSDictionary *dictJson, NSError *error) {
        [kAppDelegate.objLoader hide];
        if(!error)
        {
            if([[dictJson valueForKey:@"success"] boolValue])
            {
                //game created successfully
                //[self showAlert:[dictJson valueForKey:@"message"]];
                
                
                [self resetAllContent];
                /*
                [btnSportName setTitle:@"TEAM SPORT" forState:UIControlStateNormal];
                [btnTeamName setTitle:@"TEAM NAME" forState:UIControlStateNormal];
                [btnTeamType setTitle:@"TEAM TYPE" forState:UIControlStateNormal];
                
                strSportID = @"";
                strSportName = @"";
                strTeamType = @"";
                strTeamname = @"";
                teamSize = 0;
                */
                [arrTeamPlayers removeAllObjects];
                [tblTeam reloadData];
                
                [self.tabBarController setSelectedIndex:1];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clkSlider:(id)sender {
    if(selectedTeam)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkButton:(id)sender {
    
    [self hideAllPickers];
    
    
    //to get Navigationbar subviews
    [self showAllViews];
    
    UIButton *btn = (UIButton*)sender;
    
    
    if (btn.tag == sportname)
    {
        pickerselected = sportname;
        pickerSports.hidden = NO;
        toolBarSuperView.hidden = NO;
        
    }
    else if (btn.tag == teamname){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Team Name"
                                                                                  message: @"Choose your teamname"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Team Name";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            
            strTeamname = namefield.text;
            [btnTeamName setTitle:strTeamname forState:UIControlStateNormal];
            
            if([[strTeamname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
            {
                strTeamname = @"";
                [btnTeamName setTitle:@"TEAM NAME" forState:UIControlStateNormal];
            }
            
            NSLog(@"%@",namefield.text);
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (btn.tag == teamtype)
    {
        
        pickerselected = teamtype;
        pickerType.hidden = NO;
        toolBarSuperView.hidden = NO;
        
        
    }
    
    //[self createNewGame];
}


-(void)hideAllPickers
{
    pickerSports.hidden =YES;
    pickerType.hidden = YES;
    toolBarSuperView.hidden = YES;
    searchbar.hidden = YES;
    tblSearchResult.hidden = YES;
    [arrSearchResult removeAllObjects];
    [tblSearchResult reloadData];
    
    searchbar.text = @"";
    
    [self searchBarTextDidEndEditing:searchbar];
    
}

-(void)resetAllContent
{
    [self hideAllPickers];
    
    imgSelectedImage.hidden = YES;
    
//    btnMenu.hidden = NO;
//    lblTittle.hidden = NO;
//    btnSave.hidden = NO;
//    
//    searchbar.text = @"";
//    searchbar.hidden = YES;
//    tblSearchResult.hidden = YES;
    
    [self showAllViews];
    
    [arrSearchResult removeAllObjects];
    [tblSearchResult reloadData];
    
    strSportName = nil;
    strSportID = nil;
    strTeamname = nil;
    strTeamType = nil;
    
    
    [btnTeamName setTitle:@"TEAM NAME" forState:UIControlStateNormal];
    [btnTeamType setTitle:@"TEAM TYPE" forState:UIControlStateNormal];
    [btnSportName setTitle:@"TEAM SPORT" forState:UIControlStateNormal];

    lblteamCurrentMembers.text = @"MEMBERS (0)";
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    if (pickerView == pickerSports) {
        return  [ModelManager modelManager].sportsManager.arraySports.count;
    }
    else if (pickerView == pickerType)
        return 2;
    
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView == pickerSports) {
        Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
            return  sport.sportName;
    }
    else if (pickerView == pickerType)
    {
        return arraySportsType[row];
    }

    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == pickerSports)
    {
        Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
        strSportName=  sport.sportName;
        strSportID = sport.sportID;
    }
    
    else if (pickerView == pickerType)
    {
        strTeamType = arraySportsType[row];
    }
    
    NSLog(@"Sport Name : %@",strSportName);
}




#pragma mark - Segment control
- (IBAction)clkSegment:(UISegmentedControl*)sender
{
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        NSLog(@"sport");
        //[self.navigationController popViewControllerAnimated:NO];
        
        NSArray *arrControlers = self.tabBarController.viewControllers;
        
        Add_VC *addTeam = [kMainStoryboard instantiateViewControllerWithIdentifier:@"add_vc"];
        
        addTeam.title=@"ADD";
        addTeam.tabBarItem.image=[UIImage imageNamed:@"add.png"];
        
        
        UIViewController *thisIsTheViewControllerIWantToSetNow = addTeam;
        int indexForViewControllerYouWantToReplace = 2;
        
        NSMutableArray *tabbarViewControllers = [arrControlers mutableCopy];
        
        [tabbarViewControllers replaceObjectAtIndex:indexForViewControllerYouWantToReplace withObject:thisIsTheViewControllerIWantToSetNow];
        

        
        self.tabBarController.viewControllers = tabbarViewControllers;
        
        }
    
}


- (IBAction)clkSave:(id)sender
{
    
    if ([self validateData])
    {
        [self createNewTeam];
    }
    
}

-(BOOL)validateData
{
    return YES;
}



-(void)clkDone:(id)sender
{
    if (pickerselected == sportname)
    {
        if (strSportName == nil)
        {
            Sport *sport = [[ModelManager modelManager].sportsManager.arraySports objectAtIndex:0];
            
            strSportName = sport.sportName;
            strSportID = sport.sportID;
        }
        
        imgSelectedImage.hidden = NO;
        NSString *strImageName = [strSportName lowercaseString];
        imgSelectedImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strImageName]];
        
        [btnSportName setTitle:strSportName forState:UIControlStateNormal];
        
        //call the search api for users with same sport preference in nearby region
        
        [model_manager.playerManager getNearByUsersWithSportID:strSportID completion:^(NSMutableArray *arrayUsers, NSError *error) {
            if(!error)
            {
                if(arrayUsers.count>0)
                {
                    arrayPrefferedSportsUsers = arrayUsers;
                }
            }
        }];
    }
    
    else if (pickerselected == teamtype)
    {
        if (strTeamType == nil)
        {
            strTeamType = arraySportsType[0];
        }
        [btnTeamType setTitle:strTeamType forState:UIControlStateNormal];
    }

    
    [self hideAllPickers];
}


#pragma mark - Delegates and Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tblSearchResult) {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", ((User*)[arrSearchResult objectAtIndex:indexPath.row]).firstName, ((User*)[arrSearchResult objectAtIndex:indexPath.row]).lastName];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        TB_AddTeam *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        UIButton *btn_accept,*btn_reject;

        if (cell == nil)
        {
            cell = [[TB_AddTeam alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
        
        btn_accept = (UIButton *)[cell.contentView viewWithTag:111];
        [btn_accept addTarget:self action:@selector(clkAccept) forControlEvents:UIControlEventTouchUpInside];

        btn_reject = (UIButton *)[cell.contentView viewWithTag:222];
        [btn_reject addTarget:self action:@selector(clkReject) forControlEvents:UIControlEventTouchUpInside];

        
        cell.imgProfile.layer.cornerRadius = 5;
        cell.imgProfile.layer.masksToBounds = YES;
        
        cell.lblName.text =@"";
        btn_accept.hidden = YES;
        btn_reject.hidden = YES;

        cell.lblName.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor clearColor];
        cell.alpha = 1;

        //check for last row
        
        if (indexPath.row == (arrTeamPlayers.count)) {
            if(selectedTeam)
            {
                cell.imgProfile.image = nil;
                if([selectedTeam.creator.userID isEqualToString:model_manager.profileManager.owner.userID])
                {
                    cell.lblName.text =@"";
                    btn_accept.hidden = YES;
                    btn_reject.hidden = YES;
                }
                
                else if(selectedTeam.arrayMembers.count>0)
                {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", model_manager.profileManager.owner.userID];
                    NSArray *filteredArray = [selectedTeam.arrayMembers filteredArrayUsingPredicate:predicate];
                    
                    
                    if(filteredArray.count>0) {
                        User *filteredResult = (User*)[filteredArray objectAtIndex:0];
                        if(!filteredResult.teamStatus)
                        {
//                            cell.lblName.text = @"JOIN TEAM";
//                            cell.lblName.textAlignment = NSTextAlignmentCenter;
//                            cell.backgroundColor = [UIColor colorWithRed:114/255.0 green:204/255.0 blue:74/255.0 alpha:1];
                            
                            btn_accept.hidden = NO;
                            btn_reject.hidden = NO;

                        }
                        else
                        {
                            cell.lblName.text = @"";
                            btn_accept.hidden = YES;
                            btn_reject.hidden = YES;

                        }

                    }
                    else
                    {
                        cell.lblName.text =@"";
                        btn_accept.hidden = YES;
                        btn_reject.hidden = YES;

                    }
                }
                else
                {
                    cell.lblName.text =@"";
                    btn_accept.hidden = YES;
                    btn_reject.hidden = YES;
                }

            }
            else
            {
                cell.imgProfile.image = [UIImage imageNamed:@"newteamplayer.png"];
                cell.lblName.text = @"Add team member";
                cell.backgroundColor = [UIColor clearColor];
            }
        }
        else{
            [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrlPath,((User*)[arrTeamPlayers objectAtIndex:indexPath.row]).profilePic]] placeholderImage:[UIImage imageNamed:@"members.png"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            cell.lblName.text = [NSString stringWithFormat:@"%@ %@", [((User*)[arrTeamPlayers objectAtIndex:indexPath.row]).firstName capitalizedString], [((User*)[arrTeamPlayers objectAtIndex:indexPath.row]).lastName capitalizedString]];
            
            if(((User*)[arrTeamPlayers objectAtIndex:indexPath.row]).teamStatus)
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.alpha = 1;
            }
            else
            {
                cell.backgroundColor = [UIColor grayColor];
                cell.alpha = 0.5;
            }
        }
        
        //        Game *game = [arrSports objectAtIndex:indexPath.row];
        //
        //        cell.contentView.backgroundColor = [UIColor blackColor];
        //        cell.lblName.text = game.sportName;
        //        // cell.lblName.textColor = [UIColor whiteColor];
        //
        //        NSLog(@"time : %@, %@",game.time,game.date);
        //        cell.lblGame1.text = game.time;
        //        cell.lblGame2.text = game.date;
        //
        //        cell.imgBackground.image = [UIImage imageNamed:@"cricket.png"];
        
        tblTeam.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSearchResult) {
        return 30;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (theTableView == tblSearchResult) {
        return [arrSearchResult count];
    }
    return [arrTeamPlayers count] + 1;
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
    if(tableView ==  tblSearchResult)
    {
        NSLog(@"Search Result Selected");
        User *selectedUser = [((User*)[arrSearchResult objectAtIndex:indexPath.row]) copy];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", selectedUser.userID];
        NSArray *filteredArray = [arrTeamPlayers filteredArrayUsingPredicate:predicate];
        
        if(filteredArray.count==0) {
            
            [arrTeamPlayers addObject:selectedUser];
            
            int heightContent = ((int)arrTeamPlayers.count+1)*44;
            contentviewHeight.constant = 185+heightContent;
            
            lblteamCurrentMembers.text = [NSString stringWithFormat:@"MEMBERS (%lu)",(unsigned long)arrTeamPlayers.count];
            
            [tblTeam reloadData];
        }
        
//        btnMenu.hidden = NO;
//        lblTittle.hidden = NO;
//        btnSave.hidden = NO;
//        searchbar.hidden = YES;
//        searchbar.text = @"";
//        tblSearchResult.hidden = YES;
        
        
        [self showAllViews];
        
        [arrSearchResult removeAllObjects];
        [tblSearchResult reloadData];
        [searchbar resignFirstResponder];
    }
    else{
        if (indexPath.row == (arrTeamPlayers.count)) {
            
            if(selectedTeam)
            {
                NSLog(@"Join/Leave called");
//                if(selectedTeam.arrayMembers.count>0)
//                {
//                    
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", model_manager.profileManager.owner.userID];
//                    NSArray *filteredArray = [selectedTeam.arrayMembers filteredArrayUsingPredicate:predicate];
//                    
//                    if(filteredArray.count>0) {
//                        User *filteredResult = (User*)[filteredArray objectAtIndex:0];
//                        
//                        [kAppDelegate.objLoader show];
//                        [selectedTeam acceptTeamRequestWithRequestID:filteredResult.teamRequestID completion:^(NSDictionary *dictJson, NSError *error) {
//                            
//                            [selectedTeam getTeamDetails:^(NSDictionary *dictJson, NSError *error) {
//                                [kAppDelegate.objLoader hide];
//                                if(!error)
//                                {
//                                    if([[dictJson valueForKey:@"success"] boolValue])
//                                    {
//                                        [arrTeamPlayers removeAllObjects];
//                                        [arrTeamPlayers addObjectsFromArray:selectedTeam.arrayMembers];
//                                        int heightContent = ((int)arrTeamPlayers.count+1)*44;
//                                        contentviewHeight.constant = 185+heightContent;
//                                        [tblTeam reloadData];
//                                        
//                                        lblteamCurrentMembers.text = [NSString stringWithFormat:@"MEMBERS (%lu)",(unsigned long)arrTeamPlayers.count];
//                                    }
//                                    else
//                                    {
//                                        [self showAlert:[dictJson valueForKey:@"message"]];
//                                    }
//                                }
//                            }];
//                        }];
//                    }
//                }
                
            }
            else
            {
                if(strSportID==nil)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select team sport first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                NSLog(@"Add new player called");
                
//                btnMenu.hidden = YES;
//                lblTittle.hidden = YES;
//                btnSave.hidden = YES;
//                searchbar.hidden = NO;
//                tblSearchResult.hidden = YES;
                
                //[self searchBarTextDidEndEditing:searchbar];
                [self hideAllViews];
                [searchbar becomeFirstResponder];
            }
        }
    }
    

}




-(void)hideAllViews
{
    btnMenu.hidden = YES;
    lblTittle.hidden = YES;
    btnSave.hidden = YES;
    searchbar.hidden = NO;
    tblSearchResult.hidden = YES;
}

-(void)showAllViews
{
    tblSearchResult.hidden = YES;
    searchbar.text = @"";
    searchbar.hidden = YES;
    
    btnMenu.hidden = NO;
    lblTittle.hidden = NO;
    btnSave.hidden = NO;

}

#pragma mark - Searchbar Delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    [arrSearchResult removeAllObjects];
    arrSearchResult = [NSMutableArray arrayWithArray:arrayPrefferedSportsUsers];
    
    [tblSearchResult reloadData];
    if(arrSearchResult.count>0)
    {
        tblSearchResult.hidden = NO;
        [self.view bringSubviewToFront:tblSearchResult];
    }
    else
    {
        tblSearchResult.hidden = YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        tblSearchResult.hidden = YES;
        [arrSearchResult removeAllObjects];
        [tblSearchResult reloadData];
    }
    
    else if(searchBar.text.length>0)
    {
        [self updateSearchResults];
    }
    
    /*
    if(postAutoComplete)
        [postAutoComplete cancel];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:model_manager.profileManager.owner.userID,@"user_id",searchText,@"search_term",nil];
    
    postAutoComplete = [manager POST:[NSString stringWithFormat:@"%@games/getAutoFill",kBaseUrlPath] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //doing something
        if(((NSArray*)responseObject).count>0 && [searchBar isFirstResponder])
        {
            tblSearch.hidden = NO;
            [arrSearchResult removeAllObjects];
            [arrSearchResult addObjectsFromArray:(NSArray*)responseObject];
            
            [tblSearch reloadData];
        }
        else
        {
            tblSearch.hidden = YES;
            [arrSearchResult removeAllObjects];
            [tblSearch reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error handling.
    }];
     
     */
    
    
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    //search players
//    if(searchBar.text.length>0)
//    {
//        [kAppDelegate.objLoader show];
//        [model_manager.profileManager searchUsersWithSearchTerm:searchBar.text completion:^(NSDictionary *dictJson,NSMutableArray *users, NSError *error)
//         {
//             
//             [kAppDelegate.objLoader hide];
//             if(!error)
//             {
//                 if([[dictJson valueForKey:@"success"] boolValue])
//                 {
//                     if(users.count>0)
//                     {
//                         arrSearchResult = users;
//                         [tblSearchResult reloadData];
//                         tblSearchResult.hidden = NO;
//                         [self.view bringSubviewToFront:tblSearchResult];
//                     }
//                 }
//                 else
//                 {
//                     [self showAlert:[dictJson valueForKey:@"message"]];
//                     [arrSearchResult removeAllObjects];
//                     [tblSearchResult reloadData];
//                     tblSearchResult.hidden = YES;
//                 }
//             }
//         }];
//    }
//    else
//    {
//        [arrSearchResult removeAllObjects];
//        [tblSearchResult reloadData];
//        tblSearchResult.hidden = YES;
//    }

}


-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
        return NO;
    }
    return YES;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [arrSearchResult removeAllObjects];
    [tblSearchResult reloadData];
    
    [self showAllViews];
    
    [searchbar resignFirstResponder];
}

-(void)updateSearchResults
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName contains[cd] %@",searchbar.text];
    
    NSArray *filteredArray = [arrayPrefferedSportsUsers filteredArrayUsingPredicate:predicate];
    
    [arrSearchResult removeAllObjects];
    arrSearchResult = [filteredArray mutableCopy];
    
    [tblSearchResult reloadData];
    if(arrSearchResult.count>0)
    {
        tblSearchResult.hidden = NO;
        [self.view bringSubviewToFront:tblSearchResult];
    }
    else
    {
        tblSearchResult.hidden = YES;
    }
}


-(void)clkAccept
{
    NSLog(@"Accept clicked");
    
    if(selectedTeam.arrayMembers.count>0)
    {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", model_manager.profileManager.owner.userID];
        NSArray *filteredArray = [selectedTeam.arrayMembers filteredArrayUsingPredicate:predicate];

        if(filteredArray.count>0) {
            User *filteredResult = (User*)[filteredArray objectAtIndex:0];

            [kAppDelegate.objLoader show];
            [selectedTeam acceptTeamRequestWithRequestID:filteredResult.teamRequestID completion:^(NSDictionary *dictJson, NSError *error) {

                [selectedTeam getTeamDetails:^(NSDictionary *dictJson, NSError *error) {
                    [kAppDelegate.objLoader hide];
                    if(!error)
                    {
                        if([[dictJson valueForKey:@"success"] boolValue])
                        {
                            [arrTeamPlayers removeAllObjects];
                            [arrTeamPlayers addObjectsFromArray:selectedTeam.arrayMembers];
                            int heightContent = ((int)arrTeamPlayers.count+1)*44;
                            contentviewHeight.constant = 185+heightContent;
                            [tblTeam reloadData];

                            lblteamCurrentMembers.text = [NSString stringWithFormat:@"MEMBERS (%lu)",(unsigned long)arrTeamPlayers.count];
                        }
                        else
                        {
                            [self showAlert:[dictJson valueForKey:@"message"]];
                        }
                    }
                }];
            }];
        }
    }
}

-(void)clkReject
{
    NSLog(@"Reject clicked");
    if(selectedTeam.arrayMembers.count>0)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", model_manager.profileManager.owner.userID];
        NSArray *filteredArray = [selectedTeam.arrayMembers filteredArrayUsingPredicate:predicate];
        
        if(filteredArray.count>0) {
            User *filteredResult = (User*)[filteredArray objectAtIndex:0];
            
            [kAppDelegate.objLoader show];
            [selectedTeam declineTeamRequestWithRequestID:filteredResult.teamRequestID completion:^(NSDictionary *dictJson, NSError *error) {
                
                [selectedTeam getTeamDetails:^(NSDictionary *dictJson, NSError *error) {
                    [kAppDelegate.objLoader hide];
                    if(!error)
                    {
                        if([[dictJson valueForKey:@"success"] boolValue])
                        {
                            [arrTeamPlayers removeAllObjects];
                            [arrTeamPlayers addObjectsFromArray:selectedTeam.arrayMembers];
                            int heightContent = ((int)arrTeamPlayers.count+1)*44;
                            contentviewHeight.constant = 185+heightContent;
                            [tblTeam reloadData];
                            
                            lblteamCurrentMembers.text = [NSString stringWithFormat:@"MEMBERS (%lu)",(unsigned long)arrTeamPlayers.count];
                        }
                        else
                        {
                            [self showAlert:[dictJson valueForKey:@"message"]];
                        }
                    }
                }];
            }];
        }
    }
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
