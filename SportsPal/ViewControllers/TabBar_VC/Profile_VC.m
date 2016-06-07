//
//  Profile_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 13/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Profile_VC.h"
#import "Sport.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TB_Play_Sports.h"
#import "Add_VC.h"

@interface Profile_VC ()
{
    __weak IBOutlet UIImageView *imageProfile;
    
    __weak IBOutlet UIImageView *imgRating;
    __weak IBOutlet UILabel *lblName;
    
    __weak IBOutlet UIButton *btnChallenge;
    __weak IBOutlet UIButton *btnChat;
    __weak IBOutlet UIButton *btnFav;
    
    
    __weak IBOutlet UILabel *lblAge;
    
    __weak IBOutlet UIView *contentView;
    
    __weak IBOutlet UIButton *btnMenu;
    
    __weak IBOutlet UITableView *tableGames;
    
    __weak IBOutlet UIView *viewNavbar;
    BOOL isFavourite;
    
    UITextView *txtViewDescription;
    
    NSArray *arrGames;
    __weak IBOutlet UISegmentedControl *segmentedControl;
}
- (IBAction)clkSegment:(UISegmentedControl*)sender;

- (IBAction)clkFav:(id)sender;
- (IBAction)clkSlider:(id)sender;
- (IBAction)clkChallenge:(id)sender;
- (IBAction)clkChat:(id)sender;

@end

@implementation Profile_VC

@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    isFavourite = false;
    
    if(user==nil)
    {
        user = model_manager.profileManager.owner;
        btnChallenge.hidden = YES;
        btnChat.hidden = YES;
        btnFav.hidden = YES;
        
    }
    else
    {
        [btnMenu setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        segmentedControl.hidden = YES;
    }
    
    lblName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    lblAge.text = user.dob;
    
    imageProfile.backgroundColor = [UIColor blackColor];
    imageProfile.contentMode = UIViewContentModeScaleToFill;
    [imageProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrlPath,user.profilePic]] placeholderImage:[UIImage imageNamed:@"members.png"]];
    
    int dynamicY = lblAge.frame.origin.y;
    
    
    for(int i=0; i<user.arrayPreferredSports.count; i++)
    {
        //NSString *strImageProfile = ((Sport*)[user.arrayPreferredSports objectAtIndex:0]).sportName;
        //strImageProfile = [strImageProfile lowercaseString];
        
        //imageProfile.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strImageProfile]];
        
        
        UIView *viewSport = [[UIView alloc]init];
        viewSport.tag = 777;
        
        float viewHeight = 25;
        
        //viewSport.tag = i+1;
        
        
        
        //create image view and Lable
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 15, 15)];
        imageView.image = [UIImage imageNamed:@"sports.png"];
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        [viewSport addSubview:imageView];
        
        
        //Uilable
        
        NSString *sportName = [[NSString stringWithFormat:@"%@",((Sport*)[user.arrayPreferredSports objectAtIndex:i]).sportName] uppercaseString];
        
        UILabel *lblSportName = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 95, 25)];
        lblSportName.font = [UIFont fontWithName:@"OpenSans" size:12];
        lblSportName.backgroundColor = [UIColor clearColor];
        lblSportName.text = sportName;
        lblSportName.textColor = [UIColor whiteColor];
        [viewSport addSubview:lblSportName];
        
        //------------
        
        
        if (i % 2)
        {
            dynamicY  += 40;
            viewSport.frame = CGRectMake(15, dynamicY, 120, viewHeight) ;
        }
        
        else
        {
            viewSport.frame = CGRectMake(self.view.frame.size.width- 140, dynamicY, 120, viewHeight) ;
        }
        
        //viewSport.backgroundColor = [UIColor redColor];
        [contentView addSubview:viewSport];
    }
    
    dynamicY +=30;
    
    txtViewDescription = [[UITextView alloc]initWithFrame:CGRectMake(20, dynamicY, self.view.frame.size.width-40, 160)];
    txtViewDescription.textColor = [UIColor whiteColor];
    txtViewDescription.delegate = self;
    [contentView addSubview:txtViewDescription];
    txtViewDescription.font = [UIFont fontWithName:@"OpenSans" size:12];
    txtViewDescription.backgroundColor =[UIColor clearColor];
    txtViewDescription.text = user.bio;
    txtViewDescription.userInteractionEnabled = NO;
    
    self.view.backgroundColor = kBlackColor;
    contentView.backgroundColor = kBlackColor;
    viewNavbar.backgroundColor = kBlackColor;
    tableGames.backgroundColor = kBlackColor;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //Array Games
    arrGames = model_manager.profileManager.owner.arrayGames;
    
    
    //Default selected index
    segmentedControl.selectedSegmentIndex = 0;
    tableGames.hidden = YES;
    [tableGames reloadData];
    
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"isLocation"];
    
    if([[NSString stringWithFormat:@"%i",[user.userID intValue]] isEqualToString:[NSString stringWithFormat:@"%i",[model_manager.profileManager.owner.userID intValue]]])
    {
        __block User *_user = self.user;
        [model_manager.profileManager.owner getUserDetails:^(NSDictionary *dictJson, NSError *error) {
            if(!error)
            {
                if([[dictJson valueForKey:@"success"] boolValue])
                {
                    if(_user==nil)
                    {
                        _user = model_manager.profileManager.owner;
                    }
                    else
                    {
                        
                    }
                    
                    lblName.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
                    
                    lblAge.text = _user.dob;
                    
                    [imageProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrlPath,user.profilePic]] placeholderImage:[UIImage imageNamed:@"members.png"]];
                    
                    
                    UIView *removeView;
                    while((removeView = [contentView viewWithTag:777]) != nil) {
                        [removeView removeFromSuperview];
                    }
                    
                    
                    int dynamicY = lblAge.frame.origin.y;
                    for(int i=0; i<_user.arrayPreferredSports.count; i++)
                    {
                        //imageProfile.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[((Sport*)[_user.arrayPreferredSports objectAtIndex:0]).sportName lowercaseString]]];
                        
                        UIView *viewSport = [[UIView alloc]init];
                        viewSport.tag = 777;
                        
                        float viewHeight = 25;
                        
                        
                        
                        
                        //create image view and Lable
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 15, 15)];
                        imageView.image = [UIImage imageNamed:@"sports.png"];
                        imageView.contentMode =UIViewContentModeScaleAspectFit;
                        [viewSport addSubview:imageView];
                        
                        
                        //Uilable
                        
                        NSString *sportName = [[NSString stringWithFormat:@"%@",((Sport*)[_user.arrayPreferredSports objectAtIndex:i]).sportName] uppercaseString];
                        
                        UILabel *lblSportName = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 95, 25)];
                        lblSportName.font = [UIFont fontWithName:@"OpenSans" size:12];
                        lblSportName.backgroundColor = [UIColor clearColor];
                        lblSportName.text = sportName;
                        lblSportName.textColor = [UIColor whiteColor];
                        [viewSport addSubview:lblSportName];
                        
                        //------------
                        
                        
                        if (i % 2)
                        {
                            dynamicY  += 40;
                            viewSport.frame = CGRectMake(15, dynamicY, 120, viewHeight) ;
                        }
                        
                        else
                        {
                            viewSport.frame = CGRectMake(self.view.frame.size.width- 140, dynamicY, 120, viewHeight) ;
                        }
                        
                        viewSport.backgroundColor = [UIColor clearColor];
                        [contentView addSubview:viewSport];
                    }
                    
                    dynamicY +=30;
                    
                    txtViewDescription.frame = CGRectMake(20, dynamicY, self.view.frame.size.width-40, 160);
                    txtViewDescription.text = _user.bio;
                }
            }
        }];
    }
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

- (IBAction)clkSegment:(UISegmentedControl*)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        tableGames.hidden = YES;
    }
    else if (selectedSegment == 1)
    {
        tableGames.hidden = NO;
        [tableGames reloadData];
    }
}

- (IBAction)clkFav:(id)sender {
    
    if (isFavourite)
    {
        [btnFav setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
        isFavourite = false;
    }
    else
    {
        [btnFav setImage:[UIImage imageNamed:@"favOn.png"] forState:UIControlStateNormal];
        isFavourite = true;
    }
    
    
}

- (IBAction)clkSlider:(id)sender {
    if(![[NSString stringWithFormat:@"%i",[user.userID intValue]] isEqualToString:model_manager.profileManager.owner.userID])
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkChallenge:(id)sender {
}

- (IBAction)clkChat:(id)sender {
}


#pragma mark - Delegates and Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == tableGames) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        TB_Play_Sports *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[TB_Play_Sports alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        Game *game = [arrGames objectAtIndex:indexPath.row];
        
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
        
        cell.contentView.backgroundColor =  kBlackColor;
        
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (theTableView == tableGames)
    {
        return [arrGames count];
    }
    
    return [arrGames count];
    
}




#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
    
    Add_VC *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"add_vc"];
    viewcontroller.selectedGame = (Game*)[arrGames objectAtIndex:indexPath.row];
    [kAppDelegate.container.centerViewController pushViewController:viewcontroller animated:YES];
    
}
@end
